#!/bin/bash
# Test script for xLights command-line rendering tools
# This script demonstrates the usage of the new command-line tools

set -e  # Exit on error

echo "=========================================="
echo "xLights Command-Line Rendering Tools Test"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}This test demonstrates the new command-line capabilities added to xLights:${NC}"
echo ""
echo "1. Render XSQ to FSEQ (existing capability)"
echo "   Command: xLights -s <show_dir> -r <sequence.xsq>"
echo ""
echo "2. Render XSQ to Video (NEW capability)"
echo "   Command: xLights -s <show_dir> -r -e <sequence.xsq>"
echo ""

echo -e "${YELLOW}=== Test Cases ===${NC}"
echo ""

# Test Case 1: Basic FSEQ rendering
echo -e "${GREEN}Test 1: Basic FSEQ rendering (existing feature)${NC}"
echo "Command: xLights -s /path/to/show -r mysequence.xsq"
echo "Expected: Renders mysequence.xsq to FSEQ format and exits"
echo ""

# Test Case 2: Video export with default path
echo -e "${GREEN}Test 2: Video export with default path${NC}"
echo "Command: xLights -s /path/to/show -r -e mysequence.xsq"
echo "Expected: Renders to both FSEQ and MP4 (mysequence.mp4)"
echo ""

# Test Case 3: Video export with custom file path
echo -e "${GREEN}Test 3: Video export with custom file path${NC}"
echo "Command: xLights -s /path/to/show -r -e -vo /output/video.mp4 mysequence.xsq"
echo "Expected: Creates /output/video.mp4"
echo ""

# Test Case 4: Batch render with directory path
echo -e "${GREEN}Test 4: Batch render multiple sequences to directory${NC}"
echo "Command: xLights -s /path/to/show -r -e -vo /videos/ seq1.xsq seq2.xsq seq3.xsq"
echo "Expected: Creates /videos/seq1.mp4, /videos/seq2.mp4, /videos/seq3.mp4"
echo ""

# Test Case 5: Invalid usage - export without render
echo -e "${GREEN}Test 5: Invalid usage - export video without render mode${NC}"
echo "Command: xLights -s /path/to/show -e mysequence.xsq"
echo "Expected: Error message - '-e requires -r mode'"
echo ""

echo -e "${YELLOW}=== Code Changes Summary ===${NC}"
echo ""
echo "Files Modified:"
echo "  • xLights/xLightsApp.cpp - Added -e and -vo command-line options"
echo "  • xLights/xLightsMain.h - Added RENDER_EXPORT_VIDEO flag"
echo "  • xLights/TabSequence.cpp - Added video export to batch render"
echo ""
echo "Files Added:"
echo "  • COMMAND_LINE_TOOLS.md - Complete documentation"
echo ""

echo -e "${YELLOW}=== Implementation Details ===${NC}"
echo ""
echo "New Command-Line Flags:"
echo "  -e, --export-video     Enable video export (requires -r)"
echo "  -vo, --video-output    Specify video output path (file or directory)"
echo ""
echo "Flag Values:"
echo "  RENDER_EXIT_ON_DONE = 1    (existing)"
echo "  RENDER_ALREADY_RETRIED = 2 (existing)"
echo "  RENDER_EXPORT_VIDEO = 4    (NEW)"
echo ""

echo -e "${YELLOW}=== Validation Features ===${NC}"
echo ""
echo "✓ Validates -e requires -r mode"
echo "✓ Warns when using file path with multiple sequences"
echo "✓ Smart directory vs file path detection"
echo "✓ Automatic filename generation for directories"
echo ""

echo -e "${GREEN}=== Test Complete ===${NC}"
echo ""
echo "To actually build and test xLights with these changes:"
echo "1. Follow instructions in README.linux to install dependencies"
echo "2. Run 'make' to build xLights"
echo "3. Test with a real show directory and sequence files"
echo ""
echo "Example build commands:"
echo "  $ sudo apt-get install <dependencies from README.linux>"
echo "  $ make"
echo "  $ ./bin/xLights -h  # Check for new -e and -vo flags"
echo ""
