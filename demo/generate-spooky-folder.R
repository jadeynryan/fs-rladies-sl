library(fs)

# Set up root directory
root_dir <- path("demo/spooky-folder")
dir_create(root_dir)

# Subfolders (intentionally inconsistent names)
subdirs <- c("Data", "images", "R", "Misc Files", "REPORTS")
dir_create(path(root_dir, subdirs))

# Spooky file names and extensions
files <- c(
  "BlackCats.png",
  "ghost data.csv",
  "Pumpkin-Stats.CSV",
  "vampireBATS.txt",
  "WITCH_list.docx",
  "untitled 10 31.R",
  "ghost data (final).CSV",
  "ghost data (final) v2.CSV",
  "haunted_house.xlsx",
  "skeletonReport.doc",
  "skeletonReport.qmd",
  "witchCauldron.png",
  "ghost-viz.R"
)

# Randomly assign files to subdirectories
set.seed(1031) # Halloween 🎃
files |>
  purrr::map(\(file) {
    dir_choice <- sample(subdirs, 1)
    file_path <- path(root_dir, dir_choice, file)
    file_create(file_path)
  })

# Print result
dir_tree(root_dir)
