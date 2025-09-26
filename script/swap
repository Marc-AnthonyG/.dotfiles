#!/bin/bash

# Check if correct number of arguments provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <original_file_path> <new_file_path>"
    echo "Example: $0 /home/user/myfile.txt /backup/myfile.txt"
    echo "         $0 /home/user/myfile.txt .  (keeps original name)"
    exit 1
fi

original_path="$1"
new_path="$2"

# If new_path is just ".", use the current directory with original filename
if [ "$new_path" = "." ]; then
    original_basename=$(basename "$original_path")
    new_path="$(pwd)/$original_basename"
fi

# Check if original file/folder exists
if [ ! -e "$original_path" ]; then
    echo "Error: Original path '$original_path' does not exist."
    exit 1
fi

# Check if original path is already a symlink
if [ -L "$original_path" ]; then
    echo "Warning: '$original_path' is already a symlink. Skipping operation."
    exit 1
fi

# Create destination directory if it doesn't exist
new_dir=$(dirname "$new_path")
if [ ! -d "$new_dir" ]; then
    echo "Creating destination directory: $new_dir"
    mkdir -p "$new_dir"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create destination directory '$new_dir'"
        exit 1
    fi
fi

# Check if destination already exists
if [ -e "$new_path" ]; then
    echo "Error: Destination '$new_path' already exists."
    exit 1
fi

# Copy the file/folder to new location
echo "Copying '$original_path' to '$new_path'..."
if [ -d "$original_path" ]; then
    # It's a directory
    cp -r "$original_path" "$new_path"
else
    # It's a file
    cp "$original_path" "$new_path"
fi

# Check if copy was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to copy '$original_path' to '$new_path'"
    exit 1
fi

# Remove the original file/folder
echo "Removing original '$original_path'..."
rm -rf "$original_path"

if [ $? -ne 0 ]; then
    echo "Error: Failed to remove original '$original_path'"
    echo "The copy was successful, but cleanup failed. You may need to manually remove the original."
    exit 1
fi

# Get absolute path for the symlink target
new_absolute_path=$(realpath "$new_path")

# Create symlink from original location to new location (using absolute path)
echo "Creating symlink from '$original_path' to '$new_absolute_path'..."
ln -s "$new_absolute_path" "$original_path"

if [ $? -ne 0 ]; then
    echo "Error: Failed to create symlink"
    echo "The file/folder has been moved to '$new_absolute_path' but the symlink creation failed."
    echo "You can manually create it with: ln -s '$new_absolute_path' '$original_path'"
    exit 1
fi

echo "Success! '$original_path' has been moved to '$new_absolute_path' and symlinked."
echo "Original location now points to: $(readlink "$original_path")"
