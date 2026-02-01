# xLights Command-Line Rendering Tools

This document describes how to use xLights command-line tools for automated sequence rendering.

## Overview

xLights supports headless batch rendering of sequence files (XSQ) to FSEQ and video formats without requiring the GUI. This is useful for automation, CI/CD pipelines, and batch processing.

## Prerequisites

- xLights installed and configured
- Show directory with proper configuration (`xlights_rgbeffects.xml`)
- Sequence files (`.xsq`) to render
- For video export: FFmpeg codecs must be available

## Tool 1: Rendering XSQ to FSEQ

### Description
Renders one or more XSQ sequence files to FSEQ format, which can then be played back on FPP (Falcon Player) or other lighting controllers.

### Usage
```bash
xLights -s <show_directory> -r <sequence1.xsq> [sequence2.xsq ...]
```

### Parameters
- `-s` or `--show`: Specify the show directory containing `xlights_rgbeffects.xml`
- `-r` or `--render`: Enable render mode (renders and exits)
- Sequence files: One or more `.xsq` files to render (can be full paths or relative to show directory)

### Examples

Render a single sequence:
```bash
xLights -s /home/user/myshow -r Christmas2024.xsq
```

Render multiple sequences:
```bash
xLights -s /home/user/myshow -r seq1.xsq seq2.xsq seq3.xsq
```

Render with absolute paths:
```bash
xLights -s /home/user/myshow -r /home/user/myshow/sequences/show1.xsq
```

### Output
- FSEQ files are created in the same directory as the sequence files (or in the configured FSEQ directory)
- Progress is logged to stdout
- Exit code 0 on success, non-zero on failure

## Tool 2: Rendering XSQ to Video

### Description
Renders one or more XSQ sequence files to video format (MP4 by default). The video shows the sequence preview window animation.

### Usage
```bash
xLights -s <show_directory> -r -e <sequence1.xsq> [sequence2.xsq ...]
xLights -s <show_directory> -r -e -vo <output_path> <sequence.xsq>
```

### Parameters
- `-s` or `--show`: Specify the show directory containing `xlights_rgbeffects.xml`
- `-r` or `--render`: Enable render mode (renders and exits)
- `-e` or `--export-video`: Enable video export during rendering
- `-vo` or `--video-output`: (Optional) Specify video output path
  - If a **directory**: Videos are created in that directory with sequence name + .mp4
  - If a **file path**: Video is written to that exact path (useful for single sequence)
  - If **omitted**: Videos are created next to FSEQ files with .mp4 extension
- Sequence files: One or more `.xsq` files to render

### Examples

Render sequence to FSEQ and video (default output path):
```bash
xLights -s /home/user/myshow -r -e Christmas2024.xsq
# Output: Christmas2024.fseq and Christmas2024.mp4
```

Render with custom video output file:
```bash
xLights -s /home/user/myshow -r -e -vo /home/user/videos/christmas.mp4 Christmas2024.xsq
# Output: /home/user/videos/christmas.mp4
```

Render with video output directory (recommended for multiple sequences):
```bash
xLights -s /home/user/myshow -r -e -vo /home/user/videos/ seq1.xsq seq2.xsq
# Output: /home/user/videos/seq1.mp4, /home/user/videos/seq2.mp4
```

Batch render multiple sequences to video:
```bash
xLights -s /home/user/myshow -r -e seq1.xsq seq2.xsq seq3.xsq
# Outputs: seq1.mp4, seq2.mp4, seq3.mp4 (plus FSEQ files, in sequence directory)
```

### Output
- FSEQ files are created as with regular rendering
- Video files (MP4) are created with the same base name as the sequence (unless `-vo` is specified)
- Default codec: H.264 with reasonable quality settings
- Progress is logged to stdout
- Exit code 0 on success, non-zero on failure

## Common Options

### Show Directory (`-s`)
The show directory must contain:
- `xlights_rgbeffects.xml` - Main configuration file
- Model definitions
- Controller configurations
- Any resources referenced by sequences (images, videos, etc.)

If not specified, xLights will use the last opened show directory from preferences.

### Media Directory (`-m`)
Optionally specify a different media directory:
```bash
xLights -s /home/user/myshow -m /media/audio -r sequence.xsq
```

## Automation Examples

### Bash Script for Batch Processing
```bash
#!/bin/bash
SHOW_DIR="/home/user/myshow"
SEQUENCES="seq1.xsq seq2.xsq seq3.xsq"

echo "Rendering sequences to FSEQ and video..."
xLights -s "$SHOW_DIR" -r -e $SEQUENCES

if [ $? -eq 0 ]; then
    echo "Rendering completed successfully"
else
    echo "Rendering failed"
    exit 1
fi
```

### CI/CD Pipeline Integration
```yaml
# Example GitHub Actions workflow
# NOTE: This example assumes xLights is available in a PPA or package repository.
# Adjust the installation method based on your environment and verify that
# the installed version includes the video export feature.
name: Render Sequences
on: [push]
jobs:
  render:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install xLights
        run: |
          # Example: Add xLights PPA (verify version/availability)
          sudo add-apt-repository ppa:chris-debenham/xlights
          sudo apt-get update
          sudo apt-get install xlights
          # Alternative: Download specific release from GitHub
          # wget https://github.com/xLightsSequencer/xLights/releases/download/...
      - name: Render sequences
        run: |
          xLights -s ./show -r -e *.xsq
```

## Troubleshooting

### Video Export Fails
- Ensure FFmpeg libraries are installed
- Check that video codecs are available
- Verify sufficient disk space
- Check log files for detailed error messages

### Sequence Not Found
- Use absolute paths for sequence files
- Verify show directory is correct
- Check that `xlights_rgbeffects.xml` exists in show directory

### Missing Models or Effects
- Ensure all models referenced in the sequence are defined in the show
- Verify all effect plugins are installed
- Check that media files (audio/video) are accessible

### Performance Tips
- Use `-m` to specify a local media directory if files are on network storage
- Process sequences in batches rather than all at once for very large projects
- Monitor memory usage with large sequences

## Advanced Usage

### High-Definition Rendering
To render in high definition (if normally using low-def for GUI performance):
```bash
# This feature may be available via the HTTP automation API
# Check xLights automation documentation
```

### Custom Video Settings
Video codec and quality settings are currently controlled by xLights preferences. For custom settings, modify preferences before running batch render or use the HTTP automation API.

## Getting Help

For more information:
- xLights Documentation: https://xlights.org
- xLights Wiki: https://github.com/xLightsSequencer/xLights/wiki
- Community Forum: https://nutcracker123.com/forum/
- GitHub Issues: https://github.com/xLightsSequencer/xLights/issues

## See Also
- `xlDo` - HTTP-based automation tool for controlling running xLights instance
- xSchedule - Sequence player and scheduler
- FPP - Falcon Player for playback on Raspberry Pi and other devices
