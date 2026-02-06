# GEMINI.md (Personal Instructions)

## Project File
On start, load project context: `./project/project_overview.md`

## Fix Summary Format

After completing any bug fix or code change, provide a concise summary with:

1. **Problem**: What was broken and why (include the specific code/line if relevant)
2. **Fix**: What you changed and how it resolves the issue
3. **Tests**: What tests were added or run to verify the fix

Example format:
```
**Problem**: The `scope_name` in `path/to/file.rb:XX` was doing X, which caused Y.

**Fix**: Changed `old_code` to `new_code`. Now:
- Behavior A works correctly
- Behavior B works correctly

Added/ran tests at `test/path/to/test.rb:XX` to verify.
```

## Notes

### When asked to write down notes or create reference documents:
- Place files in `./project/notes/`
- Filename format: `{Short-Description}.md`
- Examples:
  - `Add-Login-Page.md`
  - `Dashboard-Refactor.md`

### When asked to write an AI context file:
- Place files in `./project/ai_context/`
- Filename format: `{Short-Description}.md`
- Examples:
  - `Add-Login-Page.md`
  - `Dashboard-Refactor.md`
- If the file already exists, do not overwrite, append the data instead add timestamp the updates
- Be concise, prioritize faster ai context loading and minimizing ai context usage

### When asked to read a task
- Task note files are in `./project/tasks/`
- Filename format: `{Task-Description}.md`
- Examples:
  - `Add-Login-Page.md`
  - `Dashboard-Refactor.md`

### COMMANDMENTS
- always verify code that could potentially destroy data
- always verify commands that alter or destroy data
- always say no when you do not have answers, providing reasoning behind "no"
- be minimal on code comments. Less is more, none is better.
