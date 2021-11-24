# Docs - https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema
name: Bug Report
description: Found a problem? Help us improve.
title: "[BUG]: "
labels: [Bug]
# assignees:
#   - lilo-san
body:
  - type: markdown
    attributes:
      value: |
        ## Important: Read First

        Please do not make support requests on GitHub. Our issue tracker is for tracking bugs and feature requests only
        If you need help configuring the emulator please make a request on our forums or contact us on discord

        If you are unsure, start with [discord](https://discord.gg/xzwnwWwKB5)

        Please make an effort to make sure your issue isn't already reported

  - type: textarea
    id: desc
    attributes:
      label: Describe the Bug
      description: "A clear and concise description of what the bug is"
    validations:
      required: true
  - type: textarea
    id: repro
    attributes:
      label: Reproduction Steps
      description: "Steps to reproduce the behavior"
    validations:
      required: true
  - type: textarea
    id: expect
    attributes:
      label: Expected Behavior
      description: "A clear and concise description of what you expected to happen"
    validations:
      required: false
  - type: markdown
    attributes:
      value: |
        ## System Info

        Please make sure your system meets our requirements for OS version, CPU and GPU

        Performance issues as a result of not meeting our hardware requirements are not valid

  - type: input
    id: rev
    attributes:
      label: Revision
      description: "We only accept bug reports for the latest dev version. Please try upgrading before making an issue."
      placeholder: "Example: dev-xxx"
    validations:
      required: true
  - type: input
    id: cpu
    attributes:
      label: CPU
      placeholder: "Example: i5-7600"
    validations:
      required: true
  - type: input
    id: gpu
    attributes:
      label: GPU
      placeholder: "Example: GTX 1070"
    validations:
      required: true
  - type: textarea
    id: settings
    attributes:
      label: Settings
      description: "Any **non-default** settings. If you don't want to list them out, please provide screenshots of your configuration window (including hw hacks if enabled)."
    validations:
      required: false
  - type: textarea
    id: emuSettings
    attributes:
      label: Emulation Settings
      description: |
        Any non-default core settings. If you don't want to list them out, please provide screenshots of your configuration window

        Please note that the safe preset works for most games.

        If you need to modify the settings manually because a game requires you to do so to work, please state that explicitly
    validations:
      required: false
  - type: textarea
    id: screenshots
    attributes:
      label: Screenshots
      description: "If your issue is graphical in nature and you think screenshots will help illustrate your issue, you may do that here."
    validations:
      required: false
  - type: textarea
    id: logsDumps
    attributes:
      label: "Logs & Dumps"
      description: |
        Please feel free to attach any logs, dumps, etc here
    validations:
      required: false