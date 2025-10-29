# Generated with:
# quarto::qmd_to_r_script("slides.qmd", script = "demo/code-from-slides.R")

source("demo/generate-spooky-folder.R")


library("fs")
# recurse = how many levels of subdirectories to compute on. recurse = TRUE means all of them.
dir_tree(recurse = 2)


path <- path("halloween", "images", "spooky-cat", ext = "png")
path


class(path)


path_abs(path)


file_exists(path)


real_path <- path("images", "mts.webp")
file_exists(real_path)

#| eval: false
# file_show(real_path)

#| echo: false
root <- path("demo", "scary-analysis")
if (dir_exists(root)) {
  dir_delete(root)
}


root <- path("demo", "scary-analysis")
dir_create(root)


subdirs <- c("R", "data/raw", "data/processed", "output", "reports", "images")
dir_create(root, subdirs)


scripts <- path(
  root,
  "R",
  c("01-load-data.R", "02-wrangle-data.R", "03-model.R", "04-visualization.R")
)

file_create(scripts)


dir_tree("demo/scary-analysis/")

#| echo: false
other_root <- path("demo", "other-scary-analysis")
if (dir_exists(other_root)) {
  dir_delete(other_root)
}


dir_copy(path = "demo/scary-analysis", new_path = "demo/other-scary-analysis")


dir_tree("demo/scary-analysis")


dir_tree("demo/other-scary-analysis")

#| error: true
file_copy(
  "demo/scary-analysis/R/01-load-data.R",
  "demo/other-scary-analysis/R/01-load-data.R"
)


file_copy(
  "demo/scary-analysis/R/01-load-data.R",
  "demo/other-scary-analysis/R/01-load-data.R",
  overwrite = TRUE
)


dir_create("demo/scary-analysis/src")


scripts <- dir_ls("demo/scary-analysis/R")


file_move(path = scripts, new_path = "demo/scary-analysis/src")


dir_tree("demo/scary-analysis")


file_move(
  path = "demo/other-scary-analysis/R",
  new_path = "demo/other-scary-analysis/src"
)

dir_tree("demo/other-scary-analysis")


dir_delete("demo/scary-analysis/R")
dir_tree("demo/scary-analysis")


dir_tree("demo/spooky-folder/")


files_old <- dir_ls("demo/spooky-folder/", recurse = TRUE)
files_new <- janitor::make_clean_names(files_old, case = "snake")


files_old


files_new


paths <- dir_ls("demo/spooky-folder/", recurse = TRUE)
parts <- path_split(paths)
parts[1:3]


parts_clean <- purrr::map(parts, \(part) {
  janitor::make_clean_names(part, case = "snake")
})


paths_clean <- path_join(parts_clean)


paths


paths_clean


paths_almost_clean <- paths_clean

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
paths_clean <- stringr::str_replace(paths_almost_clean, pattern, ".") |>
  # Make fs_path again
  path()


paths_almost_clean


paths_clean


paths_clean <- paths_clean |>
  # Capitalize R folder name
  stringr::str_replace("/r(?=/|$)", "/R") |>
  # Capitalize R extension
  stringr::str_replace("\\.r", ".R")

# Show the updated files containing R
paths_clean |>
  stringr::str_subset("R")

#| error: true
file_move(path = paths, new_path = paths_clean)


parents <- unique(path_dir(paths_clean))
parents


for (dir in parents) {
  if (!dir_exists(dir)) {
    dir_create(dir)
  }
}
dir_create(parents)


paths <- subset(paths, !is_dir(paths))
paths_clean <- subset(paths_clean, !is_dir(paths_clean))


file_move(paths, paths_clean)

# Optionally, delete the old spooky-folder
# dir_delete("demo/spooky-folder")

dir_tree("demo/spooky_folder")


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


source("demo/generate-spooky-folder.R")


dir_tree("demo/spooky_folder")


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


# Start fresh
source("demo/generate-spooky-folder.R")
paths <- dir_ls("demo/spooky-folder", recurse = TRUE)

# Run function
paths_clean <- clean_paths("demo/spooky-folder")


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


rename_files(paths, paths_clean)


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


organize_files("demo/spooky_folder")

#| eval: false
# # Start fresh
# source("demo/generate-spooky-folder.R")
# paths <- dir_ls("demo/spooky-folder", recurse = TRUE)
#
# # Run function
# paths_clean <- clean_paths("demo/spooky-folder")
# paths_clean
#
# # Review paths_clean before running the next functions!
# rename_files(paths, paths_clean)
# organize_files("demo/spooky_folder")

files <- file_info(dir_ls("demo", recurse = TRUE))
files


files |>
  dplyr::filter(type == "directory" | stringr::str_detect(path, ".R")) |>
  dplyr::select(path, type, size, birth_time, modification_time)


files[
  files$type == "directory" | grepl("\\.R$", files$path),
  c("path", "type", "size", "birth_time", "modification_time")
]

#| echo: false

# Cleanup
dirs <- c(
  "demo/scary-analysis",
  "demo/other-scary-analysis",
  "demo/spooky-folder",
  "demo/spooky_folder"
)
dir_delete(dirs)
