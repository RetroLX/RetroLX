/*
 * Copyright © 2012 Philipp Brüschweiler
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice (including the next
 * paragraph) shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#include <errno.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <assert.h>
#include <ctype.h>
#include <unistd.h>

#include <wayland-client.h>

#include "xdg-output-unstable-v1-client-protocol.h"

#ifndef ARRAY_LENGTH
#define ARRAY_LENGTH(a) (sizeof (a) / sizeof (a)[0])
#endif

#ifndef MIN
#define MIN(x,y) (((x) < (y)) ? (x) : (y))
#endif

#define xmalloc(s) (fail_on_null(malloc(s), (s), __FILE__, __LINE__))
#define xzalloc(s) (fail_on_null(zalloc(s), (s), __FILE__, __LINE__))
#define xstrdup(s) (fail_on_null(strdup(s), 0, __FILE__, __LINE__))

typedef void (*print_info_t)(void *info);
typedef void (*destroy_info_t)(void *info);

struct global_info {
	struct wl_list link;

	uint32_t id;
	uint32_t version;
	char *interface;

	print_info_t print;
	destroy_info_t destroy;
};

struct output_mode {
	struct wl_list link;

	uint32_t flags;
	int32_t width, height;
	int32_t refresh;
};

struct output_info {
	struct global_info global;
	struct wl_list global_link;

	struct wl_output *output;

	int32_t version;

	struct {
		int32_t x, y;
		int32_t scale;
		int32_t physical_width, physical_height;
		enum wl_output_subpixel subpixel;
		enum wl_output_transform output_transform;
		char *make;
		char *model;
	} geometry;

	struct wl_list modes;
};

struct xdg_output_v1_info {
	struct wl_list link;

	struct zxdg_output_v1 *xdg_output;
	struct output_info *output;

	struct {
		int32_t x, y;
		int32_t width, height;
	} logical;

	char *name, *description;
};

struct xdg_output_manager_v1_info {
	struct global_info global;
	struct zxdg_output_manager_v1 *manager;
	struct wayland_info *info;

	struct wl_list outputs;
};

struct wayland_info {
	struct wl_display *display;
	struct wl_registry *registry;

	struct wl_list infos;
	bool roundtrip_needed;

	/* required for xdg-output-unstable-v1 */
	struct wl_list outputs;
	struct xdg_output_manager_v1_info *xdg_output_manager_v1_info;
};

static void *
fail_on_null(void *p, size_t size, char *file, int32_t line)
{
	if (p == NULL) {
		if (file)
			fprintf(stderr, "%s:%d: ", file, line);
		fprintf(stderr, "out of memory");
		if (size)
			fprintf(stderr, " (%zd)", size);
		fprintf(stderr, "\n");
		exit(EXIT_FAILURE);
	}

	return p;
}

static inline void *
zalloc(size_t size)
{
	return calloc(1, size);
}

static void
print_global_info(void *data)
{
	/*char buf[512];

	struct global_info *global = data;

	snprintf(buf, sizeof(buf), "'%s',", global->interface);

	printf("interface: %-45s version: %2u, name: %2u\n",
	       buf, global->version, global->id);*/

}

static void
init_global_info(struct wayland_info *info,
		 struct global_info *global, uint32_t id,
		 const char *interface, uint32_t version)
{
	global->id = id;
	global->version = version;
	global->interface = xstrdup(interface);

	wl_list_insert(info->infos.prev, &global->link);
}

static void
print_output_info(void *data)
{
/*	struct output_info *output = data;
	struct output_mode *mode;
	const char *subpixel_orientation;
	const char *transform;

	print_global_info(data);

	switch (output->geometry.subpixel) {
	case WL_OUTPUT_SUBPIXEL_UNKNOWN:
		subpixel_orientation = "unknown";
		break;
	case WL_OUTPUT_SUBPIXEL_NONE:
		subpixel_orientation = "none";
		break;
	case WL_OUTPUT_SUBPIXEL_HORIZONTAL_RGB:
		subpixel_orientation = "horizontal rgb";
		break;
	case WL_OUTPUT_SUBPIXEL_HORIZONTAL_BGR:
		subpixel_orientation = "horizontal bgr";
		break;
	case WL_OUTPUT_SUBPIXEL_VERTICAL_RGB:
		subpixel_orientation = "vertical rgb";
		break;
	case WL_OUTPUT_SUBPIXEL_VERTICAL_BGR:
		subpixel_orientation = "vertical bgr";
		break;
	default:
		fprintf(stderr, "unknown subpixel orientation %u\n",
			output->geometry.subpixel);
		subpixel_orientation = "unexpected value";
		break;
	}

	switch (output->geometry.output_transform) {
	case WL_OUTPUT_TRANSFORM_NORMAL:
		transform = "normal";
		break;
	case WL_OUTPUT_TRANSFORM_90:
		transform = "90°";
		break;
	case WL_OUTPUT_TRANSFORM_180:
		transform = "180°";
		break;
	case WL_OUTPUT_TRANSFORM_270:
		transform = "270°";
		break;
	case WL_OUTPUT_TRANSFORM_FLIPPED:
		transform = "flipped";
		break;
	case WL_OUTPUT_TRANSFORM_FLIPPED_90:
		transform = "flipped 90°";
		break;
	case WL_OUTPUT_TRANSFORM_FLIPPED_180:
		transform = "flipped 180°";
		break;
	case WL_OUTPUT_TRANSFORM_FLIPPED_270:
		transform = "flipped 270°";
		break;
	default:
		fprintf(stderr, "unknown output transform %u\n",
			output->geometry.output_transform);
		transform = "unexpected value";
		break;
	}

	printf("\tx: %d, y: %d,",
	       output->geometry.x, output->geometry.y);
	if (output->version >= 2)
		printf(" scale: %d,", output->geometry.scale);
	printf("\n");

	printf("\tphysical_width: %d mm, physical_height: %d mm,\n",
	       output->geometry.physical_width,
	       output->geometry.physical_height);
	printf("\tmake: '%s', model: '%s',\n",
	       output->geometry.make, output->geometry.model);
	printf("\tsubpixel_orientation: %s, output_transform: %s,\n",
	       subpixel_orientation, transform);

	wl_list_for_each(mode, &output->modes, link) {
		printf("\tmode:\n");

		printf("\t\twidth: %d px, height: %d px, refresh: %.3f Hz,\n",
		       mode->width, mode->height,
		       (float) mode->refresh / 1000);

		printf("\t\tflags:");
		if (mode->flags & WL_OUTPUT_MODE_CURRENT)
			printf(" current");
		if (mode->flags & WL_OUTPUT_MODE_PREFERRED)
			printf(" preferred");
		printf("\n");
	}*/
}

static char
bits2graph(uint32_t value, unsigned bitoffset)
{
	int c = (value >> bitoffset) & 0xff;

	if (isgraph(c) || isspace(c))
		return c;

	return '?';
}

static void
fourcc2str(uint32_t format, char *str, int len)
{
	int i;

	assert(len >= 5);

	for (i = 0; i < 4; i++)
		str[i] = bits2graph(format, i * 8);
	str[i] = '\0';
}

static void
destroy_xdg_output_v1_info(struct xdg_output_v1_info *info)
{
	wl_list_remove(&info->link);
	zxdg_output_v1_destroy(info->xdg_output);
	free(info->name);
	free(info->description);
	free(info);
}

static void
print_xdg_output_v1_info(const struct xdg_output_v1_info *info)
{
	// TODO retrieve refresh rate from wl_output
	printf("0:%dx%d 60Hz (%dx%d)\n", info->logical.width, info->logical.height, info->logical.width, info->logical.height);
	/*printf("\txdg_output_v1\n");
	printf("\t\toutput: %d\n", info->output->global.id);
	if (info->name)
		printf("\t\tname: '%s'\n", info->name);
	if (info->description)
		printf("\t\tdescription: '%s'\n", info->description);
	printf("\t\tlogical_x: %d, logical_y: %d\n",
		info->logical.x, info->logical.y);
	printf("\t\tlogical_width: %d, logical_height: %d\n",
		info->logical.width, info->logical.height);*/
}

static void
print_xdg_output_manager_v1_info(void *data)
{
	struct xdg_output_manager_v1_info *info = data;
	struct xdg_output_v1_info *output;

	print_global_info(data);

	wl_list_for_each(output, &info->outputs, link)
		print_xdg_output_v1_info(output);
}

static void
destroy_xdg_output_manager_v1_info(void *data)
{
	struct xdg_output_manager_v1_info *info = data;
	struct xdg_output_v1_info *output, *tmp;

	zxdg_output_manager_v1_destroy(info->manager);

	wl_list_for_each_safe(output, tmp, &info->outputs, link)
		destroy_xdg_output_v1_info(output);
}

static void
handle_xdg_output_v1_logical_position(void *data, struct zxdg_output_v1 *output,
                                      int32_t x, int32_t y)
{
	struct xdg_output_v1_info *xdg_output = data;
	xdg_output->logical.x = x;
	xdg_output->logical.y = y;
}

static void
handle_xdg_output_v1_logical_size(void *data, struct zxdg_output_v1 *output,
                                      int32_t width, int32_t height)
{
	struct xdg_output_v1_info *xdg_output = data;
	xdg_output->logical.width = width;
	xdg_output->logical.height = height;
}

static void
handle_xdg_output_v1_done(void *data, struct zxdg_output_v1 *output)
{
	/* Don't bother waiting for this; there's no good reason a
	 * compositor will wait more than one roundtrip before sending
	 * these initial events. */
}

static void
handle_xdg_output_v1_name(void *data, struct zxdg_output_v1 *output,
                          const char *name)
{
	struct xdg_output_v1_info *xdg_output = data;
	xdg_output->name = xstrdup(name);
}

static void
handle_xdg_output_v1_description(void *data, struct zxdg_output_v1 *output,
                          const char *description)
{
	struct xdg_output_v1_info *xdg_output = data;
	xdg_output->description = xstrdup(description);
}

static const struct zxdg_output_v1_listener xdg_output_v1_listener = {
	.logical_position = handle_xdg_output_v1_logical_position,
	.logical_size = handle_xdg_output_v1_logical_size,
	.done = handle_xdg_output_v1_done,
	.name = handle_xdg_output_v1_name,
	.description = handle_xdg_output_v1_description,
};

static void
add_xdg_output_v1_info(struct xdg_output_manager_v1_info *manager_info,
                       struct output_info *output)
{
	struct xdg_output_v1_info *xdg_output = xzalloc(sizeof *xdg_output);

	wl_list_insert(&manager_info->outputs, &xdg_output->link);
	xdg_output->xdg_output = zxdg_output_manager_v1_get_xdg_output(
		manager_info->manager, output->output);
	zxdg_output_v1_add_listener(xdg_output->xdg_output,
		&xdg_output_v1_listener, xdg_output);

	xdg_output->output = output;

	manager_info->info->roundtrip_needed = true;
}

static void
add_xdg_output_manager_v1_info(struct wayland_info *info, uint32_t id,
                               uint32_t version)
{
	struct output_info *output;
	struct xdg_output_manager_v1_info *manager = xzalloc(sizeof *manager);

	wl_list_init(&manager->outputs);
	manager->info = info;

	init_global_info(info, &manager->global, id,
		zxdg_output_manager_v1_interface.name, version);
	manager->global.print = print_xdg_output_manager_v1_info;
	manager->global.destroy = destroy_xdg_output_manager_v1_info;

	manager->manager = wl_registry_bind(info->registry, id,
		&zxdg_output_manager_v1_interface, version > 2 ? 2 : version);

	wl_list_for_each(output, &info->outputs, global_link)
		add_xdg_output_v1_info(manager, output);

	info->xdg_output_manager_v1_info = manager;
}

static void
output_handle_geometry(void *data, struct wl_output *wl_output,
		       int32_t x, int32_t y,
		       int32_t physical_width, int32_t physical_height,
		       int32_t subpixel,
		       const char *make, const char *model,
		       int32_t output_transform)
{
	struct output_info *output = data;

	output->geometry.x = x;
	output->geometry.y = y;
	output->geometry.physical_width = physical_width;
	output->geometry.physical_height = physical_height;
	output->geometry.subpixel = subpixel;
	output->geometry.make = xstrdup(make);
	output->geometry.model = xstrdup(model);
	output->geometry.output_transform = output_transform;
}

static void
output_handle_mode(void *data, struct wl_output *wl_output,
		   uint32_t flags, int32_t width, int32_t height,
		   int32_t refresh)
{
	struct output_info *output = data;
	struct output_mode *mode = xmalloc(sizeof *mode);

	mode->flags = flags;
	mode->width = width;
	mode->height = height;
	mode->refresh = refresh;

	wl_list_insert(output->modes.prev, &mode->link);
}

static void
output_handle_done(void *data, struct wl_output *wl_output)
{
	/* don't bother waiting for this; there's no good reason a
	 * compositor will wait more than one roundtrip before sending
	 * these initial events. */
}

static void
output_handle_scale(void *data, struct wl_output *wl_output,
		    int32_t scale)
{
	struct output_info *output = data;

	output->geometry.scale = scale;
}

static const struct wl_output_listener output_listener = {
	output_handle_geometry,
	output_handle_mode,
	output_handle_done,
	output_handle_scale,
};

static void
destroy_output_info(void *data)
{
	struct output_info *output = data;
	struct output_mode *mode, *tmp;

	wl_output_destroy(output->output);

	if (output->geometry.make != NULL)
		free(output->geometry.make);
	if (output->geometry.model != NULL)
		free(output->geometry.model);

	wl_list_for_each_safe(mode, tmp, &output->modes, link) {
		wl_list_remove(&mode->link);
		free(mode);
	}
}

static void
add_output_info(struct wayland_info *info, uint32_t id, uint32_t version)
{
	struct output_info *output = xzalloc(sizeof *output);

	init_global_info(info, &output->global, id, "wl_output", version);
	output->global.print = print_output_info;
	output->global.destroy = destroy_output_info;

	output->version = MIN(version, 2);
	output->geometry.scale = 1;
	wl_list_init(&output->modes);

	output->output = wl_registry_bind(info->registry, id,
					  &wl_output_interface, output->version);
	wl_output_add_listener(output->output, &output_listener,
			       output);

	info->roundtrip_needed = true;
	wl_list_insert(&info->outputs, &output->global_link);

	if (info->xdg_output_manager_v1_info)
		add_xdg_output_v1_info(info->xdg_output_manager_v1_info,
				       output);
}

static void
destroy_global_info(void *data)
{
}

static void
add_global_info(struct wayland_info *info, uint32_t id,
		const char *interface, uint32_t version)
{
	struct global_info *global = xzalloc(sizeof *global);

	init_global_info(info, global, id, interface, version);
	global->print = print_global_info;
	global->destroy = destroy_global_info;
}

static void
global_handler(void *data, struct wl_registry *registry, uint32_t id,
	       const char *interface, uint32_t version)
{
	struct wayland_info *info = data;

	if (!strcmp(interface, "wl_output"))
		add_output_info(info, id, version);
	else if (!strcmp(interface, zxdg_output_manager_v1_interface.name))
		add_xdg_output_manager_v1_info(info, id, version);
	else
		add_global_info(info, id, interface, version);
}

static void
global_remove_handler(void *data, struct wl_registry *registry, uint32_t name)
{
}

static const struct wl_registry_listener registry_listener = {
	global_handler,
	global_remove_handler
};

static void
print_infos(struct wl_list *infos)
{
	struct global_info *info;

	wl_list_for_each(info, infos, link)
		info->print(info);
}

static void
destroy_info(void *data)
{
	struct global_info *global = data;

	global->destroy(data);
	wl_list_remove(&global->link);
	free(global->interface);
	free(data);
}

static void
destroy_infos(struct wl_list *infos)
{
	struct global_info *info, *tmp;
	wl_list_for_each_safe(info, tmp, infos, link)
		destroy_info(info);
}

int
main(int argc, char **argv)
{
	struct wayland_info info;

	info.display = wl_display_connect(NULL);
	if (!info.display) {
		fprintf(stderr, "failed to create display: %s\n",
			strerror(errno));
		return -1;
	}

	info.xdg_output_manager_v1_info = NULL;
	wl_list_init(&info.infos);
	wl_list_init(&info.outputs);

	info.registry = wl_display_get_registry(info.display);
	wl_registry_add_listener(info.registry, &registry_listener, &info);

	do {
		info.roundtrip_needed = false;
		wl_display_roundtrip(info.display);
	} while (info.roundtrip_needed);

	print_infos(&info.infos);
	destroy_infos(&info.infos);

	wl_registry_destroy(info.registry);
	wl_display_disconnect(info.display);

	return 0;
}
