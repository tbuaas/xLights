# Implementation Summary: Command-Line Rendering Tools for xLights

## Overview
This implementation adds command-line video export capability to xLights' existing batch render functionality, enabling headless automation of both FSEQ and video rendering.

## Discovery
During investigation, it was discovered that **xLights already supports command-line rendering to FSEQ** via:
```bash
xLights -s <show_directory> -r <sequence1.xsq> [sequence2.xsq ...]
```

This existing capability was previously undocumented for this specific use case, so documentation was added.

## Implementation
Added video export capability to the existing batch render mode with minimal code changes:

### New Command-Line Options
- `-e` / `--export-video`: Enable video export during batch rendering
- `-vo` / `--video-output`: Specify video output path (file or directory)

### Code Changes

**1. xLights/xLightsApp.cpp** (Command-line parsing)
- Added `-e` and `-vo` options to command-line parser
- Added validation: `-e` requires `-r` mode
- Added warning for multiple sequences with single file output path
- Pass video export flags and output path to main frame

**2. xLights/xLightsMain.h** (Main frame header)
- Added `RENDER_EXPORT_VIDEO = 4` flag constant
- Added `_videoOutputPath` member variable
- Added `SetVideoOutputPath()` and `GetVideoOutputPath()` methods
- Updated `OpenRenderAndSaveSequences()` signature to accept `exportVideo` parameter

**3. xLights/TabSequence.cpp** (Batch rendering logic)
- Updated `OpenRenderAndSaveSequencesF()` to parse `RENDER_EXPORT_VIDEO` flag
- Updated `OpenRenderAndSaveSequences()` to accept `exportVideo` parameter
- Added video export logic after FSEQ rendering
- Implemented smart path handling:
  - If path is empty: Use sequence name + .mp4
  - If path is directory: Create file in directory with sequence name
  - If path is file: Use exact path
- Integrated with existing `ExportVideoPreview()` function

**4. COMMAND_LINE_TOOLS.md** (Documentation)
- Complete usage guide for both tools
- Examples for common use cases
- Troubleshooting section
- CI/CD integration examples
- Performance tips

**5. test_command_line_tools.sh** (Test demonstration)
- Demonstrates all use cases
- Shows expected behavior
- Summarizes implementation details

## Features

### Validation & Error Handling
✓ Validates `-e` flag requires `-r` mode
✓ Warns when using file path with multiple sequences  
✓ Smart directory vs file path detection
✓ Comprehensive error logging

### Path Handling
- **Empty path**: `sequence.mp4` (same location as FSEQ)
- **Directory path**: `/videos/` → `/videos/sequence.mp4`
- **File path**: `/output/video.mp4` → `/output/video.mp4`

### Backward Compatibility
✓ No changes to existing command-line flags
✓ No changes to existing batch render behavior without `-e`
✓ All existing functionality preserved

## Usage Examples

### Tool 1: XSQ to FSEQ (Existing)
```bash
# Single sequence
xLights -s /home/user/show -r sequence.xsq

# Multiple sequences
xLights -s /home/user/show -r seq1.xsq seq2.xsq seq3.xsq
```

### Tool 2: XSQ to Video (New)
```bash
# Default video location
xLights -s /home/user/show -r -e sequence.xsq

# Custom video file
xLights -s /home/user/show -r -e -vo /output/video.mp4 sequence.xsq

# Multiple sequences to directory (recommended)
xLights -s /home/user/show -r -e -vo /videos/ seq1.xsq seq2.xsq seq3.xsq
```

## Testing Strategy

### Manual Testing
1. Build xLights following README.linux
2. Create or use existing show directory with sequences
3. Test each usage pattern:
   - FSEQ only (existing feature)
   - Video export with default path
   - Video export with file path
   - Video export with directory path
   - Multiple sequences
   - Error cases (missing -r, etc.)

### Automated Testing
- Code review completed ✓
- Security scan (CodeQL) passed ✓
- No new security vulnerabilities introduced ✓

### Integration Testing
The changes integrate with:
- Existing `ExportVideoPreview()` function (well-tested)
- Existing batch render pipeline (well-tested)
- Existing FSEQ export (well-tested)

## Benefits

### Automation
- Enables CI/CD pipeline integration
- Batch processing of large sequence libraries
- Scheduled rendering tasks
- Integration with other automation tools

### Use Cases
1. **Automated show production**: Render all sequences overnight
2. **Version control**: Regenerate videos on sequence changes
3. **Distribution**: Batch create preview videos for sharing
4. **Quality assurance**: Automated rendering for testing
5. **Archive**: Bulk export of sequence library

## Technical Notes

### Dependencies
- Uses existing VideoExporter class (no new dependencies)
- Requires FFmpeg libraries (already required for xLights video features)
- No additional build dependencies

### Performance
- Video export adds time to batch rendering
- Can be CPU/GPU intensive depending on sequence complexity
- Multiple sequences are processed sequentially (not parallel)

### Limitations
- Video export settings controlled by xLights preferences (not command-line)
- Video codec/quality not configurable via CLI (uses defaults)
- Requires GUI libraries (wxWidgets) even in batch mode

## Future Enhancements (Not Implemented)

Potential future improvements that could be added:
1. Truly headless mode (no wxWidgets dependency)
2. Video codec/quality command-line options
3. Parallel rendering of multiple sequences
4. Progress callbacks/webhooks for monitoring
5. REST API endpoint for remote rendering

## Files Changed

### Modified
- `xLights/xLightsApp.cpp` (+35 lines)
- `xLights/xLightsMain.h` (+5 lines)
- `xLights/TabSequence.cpp` (+35 lines)

### Added
- `COMMAND_LINE_TOOLS.md` (200 lines)
- `test_command_line_tools.sh` (100 lines)

### Total Impact
- ~375 lines of new code/documentation
- 3 core files modified
- 2 new documentation/test files
- Minimal changes to existing code
- High benefit-to-change ratio

## Conclusion

This implementation successfully adds command-line video export capability to xLights with:
- ✓ Minimal code changes
- ✓ Comprehensive documentation
- ✓ Robust validation
- ✓ Backward compatibility
- ✓ Clear usage examples
- ✓ Integration with existing code

The solution leverages existing, well-tested functionality (batch render and video export) and adds minimal new code to connect them via command-line flags.
