changelog_file = "change.log"
rg_text_file = "ReadyGear/text.lua"

def read_and_format_changelog():
    with open(changelog_file, "r") as f:
        lines = f.readlines()
        
    # Remove line breaks and add "/" at the end of each line
    public_lines = [line.strip() + "\\" for line in lines if line[0] != "*" or line[0].isnumeric()]
    return public_lines

def update_text_file():
    with open(rg_text_file, "r") as f:
        lines = f.readlines()
    
    # Find the index of the line containing 'Text.ChangeLog = "\'
    start_index = None
    for i, line in enumerate(lines):
        if 'Text.ChangeLog = "\\' in line:
            start_index = i
            break
    
    if start_index is not None:
        # Keep lines up to and including 'Text.ChangeLog = "\'
        updated_lines = lines[:start_index + 1]
        # Append the formatted changelog lines, each followed by a newline character
        formatted_lines = read_and_format_changelog()
        for formatted_line in formatted_lines:
            updated_lines.append(formatted_line + '\n')
        # Write the updated content back to the file
        with open(rg_text_file, "w") as f:
            f.writelines(updated_lines)
            f.writelines('"')
        print("Text file updated successfully.")
    else:
        print("Could not find 'Text.ChangeLog = \"' in the text file.")
        print("Please make sure the text file is up to date with the latest version of the addon.")

update_text_file()