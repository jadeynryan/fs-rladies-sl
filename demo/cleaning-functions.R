# Define functions =============================================================

clean_paths <- function(folder, recurse = TRUE) {
  # Split paths into parts
  paths <- dir_ls(folder, recurse = recurse)
  parts <- path_split(paths)

  # Clean to snake_case
  parts_clean <- purrr::map(
    parts,
    \(part) janitor::make_clean_names(part, case = "snake")
  )

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

  # Replace underscore before ext with period and make R uppercase
  paths_clean <- paths_clean |>
    stringr::str_replace(pattern, ".") |>
    # Capitalize R folder name
    stringr::str_replace("/r(?=/|$)", "/R") |>
    # Capitalize R extension
    stringr::str_replace("\\.r", ".R") |>
    # Make fs_path again
    path()

  return(paths_clean)
}

rename_files <- function(old_paths, new_paths) {
  # Get parent folders
  parents <- unique(path_dir(new_paths))

  # Create parent folders
  for (dir in parents) {
    if (!dir_exists(dir)) {
      dir_create(dir)
    }
  }
  dir_create(parents)

  # Filter out folders from files
  old_paths <- subset(old_paths, !is_dir(old_paths))
  new_paths <- subset(new_paths, !is_dir(new_paths))

  # Rename files
  file_move(old_paths, new_paths)

  # See results
  dir_tree(path_common(new_paths))
}

organize_files <- function(folder) {
  # List subdirectories and extensions
  data <- dir_ls(folder, recurse = TRUE, glob = "*.csv|*.xlsx")
  images <- dir_ls(folder, recurse = TRUE, glob = "*.png")
  misc_files <- dir_ls(folder, recurse = TRUE, glob = "*.txt")
  r <- dir_ls(folder, recurse = TRUE, glob = "*.R")
  reports <- dir_ls(folder, recurse = TRUE, glob = "*.doc|*.docx|*.qmd")

  # Move files
  file_move(data, path(stringr::str_glue("{folder}/data")))
  file_move(images, path(stringr::str_glue("{folder}/images")))
  file_move(misc_files, path(stringr::str_glue("{folder}/misc_files")))
  file_move(r, path(stringr::str_glue("{folder}/R")))
  file_move(reports, path(stringr::str_glue("{folder}/reports")))

  # See results
  dir_tree(folder)
}

# Run functions ================================================================

# Re-create messy folder
source("demo/generate-spooky-folder.R")

# List all paths
paths <- dir_ls("demo/spooky-folder", recurse = TRUE)

# Clean paths
paths_clean <- clean_paths("demo/spooky-folder")

# Review paths to make sure they are correct before renaming!
paths_clean

# Rename files
rename_files(paths, paths_clean)

# Organize files by extension
organize_files("demo/spooky_folder")
