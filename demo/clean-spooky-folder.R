# This script runs generate-spooky-folder.R to create our messy folder and then
# cleans it.

library(fs)
library(stringr)
library(purrr)
library(janitor)

# Create messy spooky-folder
source("demo/generate-spooky-folder.R")

# Inspect spooky-folder
dir_tree("demo/spooky-folder")

# Clean paths ==================================================================

# List all paths
paths <- dir_ls("demo/spooky-folder/", recurse = TRUE)

# Split paths into parts
parts <- path_split(paths)

# Clean each part individually
parts_clean <- purrr::map(parts, \(part) {
  janitor::make_clean_names(part, case = "snake")
})

# Reconstruct paths
paths_clean <- path_join(parts_clean)

# Get extensions
exts <- path_ext(paths) |>
  # Remove blanks
  stringr::str_subset("\\S") |>
  # Remove duplicates
  stringr::str_unique() |>
  # Make lowercase
  stringr::str_to_lower()

# Make dynamic regex pattern including extensions
pattern <- paste0("_(?=(", paste(exts, collapse = "|"), ")$)")

# Replace underscore before ext with period
paths_clean <- stringr::str_replace(paths_clean, pattern, ".") |>
  # Make fs_path again
  path()

# Capitalize R
paths_clean <- paths_clean |>
  # Capitalize R folder name
  stringr::str_replace("/r(?=/|$)", "/R") |>
  # Capitalize R extension
  stringr::str_replace("\\.r", ".R")

# Get parent folders
parents <- unique(path_dir(paths_clean))

# Create each parent folder
parents |>
  purrr::map(\(x) {
    if (!dir_exists(x)) {
      dir_create(x)
    }
  })

# Filter out parent folders from current paths and new paths
paths <- subset(paths, !is_dir(paths))
paths_clean <- subset(paths_clean, !is_dir(paths_clean))

# Complete the file renaming
file_move(paths, paths_clean)

# See pretty, cleaned folder
dir_tree("demo/spooky_folder")

# Organize files ===============================================================

data <- dir_ls("demo/spooky_folder", recurse = TRUE, glob = "*.csv|*.xlsx")
images <- dir_ls("demo/spooky_folder", recurse = TRUE, glob = "*.png")
misc_files <- dir_ls("demo/spooky_folder", recurse = TRUE, glob = "*.txt")
r <- dir_ls("demo/spooky_folder", recurse = TRUE, glob = "*.R")
reports <- dir_ls(
  "demo/spooky_folder",
  recurse = TRUE,
  glob = "*.doc|*.docx|*.qmd"
)


file_move(data, "demo/spooky_folder/data")
file_move(images, "demo/spooky_folder/images")
file_move(misc_files, "demo/spooky_folder/misc_files")
file_move(r, "demo/spooky_folder/R")
file_move(reports, "demo/spooky_folder/reports")

# Check results & do any final manual cleaning
dir_tree("demo/spooky_folder")
