# Move the existing folder (e.g., D:\Appx) into your AutomaticInstalls repo

# Set the source and destination paths
$source = "D:\Appx"
$destination = "D:\AutomatedInstalls\Appx"  # Change this to your repo path

# Move the folder (will overwrite if already exists)
Move-Item -Path $source -Destination $destination -Force

# Change to the repo directory (should be the root, not inside Appx)
Set-Location "D:\AutomatedInstalls"

# Stage, commit, and push the changes
git add Appx
git commit -m "Add Appx folder with package files"
git push origin main