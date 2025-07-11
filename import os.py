import os
import requests

# Path to your plugin list file
plugin_list_file = r"C:\Users\mike\Desktop\Untitled-2.txt"

# Destination folder for plugins
dest_folder = r"C:\Windows\System32\search-plugins\nova3\engines"

os.makedirs(dest_folder, exist_ok=True)

with open(plugin_list_file, "r") as f:
    urls = [line.strip() for line in f if line.strip().startswith("http") and line.strip().endswith(".py")]

for url in urls:
    filename = os.path.join(dest_folder, os.path.basename(url))
    print(f"Downloading {url} -> {filename}")
    try:
        r = requests.get(url)
        r.raise_for_status()
        with open(filename, "wb") as out:
            out.write(r.content)
    except Exception as e:
        print(f"Failed to download {url}: {e}")

print("All plugins downloaded. Restart qBittorrent to use them.")