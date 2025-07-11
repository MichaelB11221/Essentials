# ========== CONFIG ==========
$repoURL    = "https://github.com/microsoft/WSA"
$repoFolder = "C:\WSA"
$outputPDFs = "D:\Windows\WSA(ToBeInWindowsDir)\2. Sources"
$wkhtmltopdf = "C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe"

# ========== STEP 1: Clone Repo (skip if already cloned) ==========
if (-not (Test-Path $repoFolder)) {
    git clone $repoURL $repoFolder
}

# ========== STEP 2: Prepare Output Folder ==========
if (-not (Test-Path $outputPDFs)) {
    New-Item -Path $outputPDFs -ItemType Directory | Out-Null
}

# ========== STEP 3: Convert .md to Pretty HTML + PDF ==========
$mdFiles = Get-ChildItem -Path $repoFolder -Recurse -Filter *.md

foreach ($file in $mdFiles) {
    $relativePath = $file.FullName.Substring($repoFolder.Length).TrimStart('\')
    $cleanName = $relativePath -replace '[\\/:*?"<>|]', '_' -replace '\.md$', ''

    $htmlPath = Join-Path $outputPDFs "$cleanName.html"
    $pdfPath  = Join-Path $outputPDFs "$cleanName.pdf"

    # Read Markdown
    $markdown = Get-Content $file.FullName -Raw

    # Escape HTML special chars
    $escaped = $markdown -replace '&', '&amp;' -replace '<', '&lt;' -replace '>', '&gt;'

    # Wrap it in prettified themed HTML
    $html = @"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>$cleanName</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css">
    <style>
        body {
            background: #1e1e1e;
            color: #d4d4d4;
            font-family: Consolas, monospace;
            font-size: 11pt;
            padding: 30px;
        }
        pre {
            overflow-x: auto;
        }
        h1, h2, h3 {
            color: #61dafb;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<h1>$cleanName</h1>
<pre><code class="language-markdown">$escaped</code></pre>
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
<script>hljs.highlightAll();</script>
</body>
</html>
"@

    # Write HTML to file
    $html | Out-File -FilePath $htmlPath -Encoding UTF8

    # Convert to PDF
    & "$wkhtmltopdf" --quiet "$htmlPath" "$pdfPath"

    if (Test-Path $pdfPath) {
        Remove-Item $htmlPath
        Write-Host "✔ $cleanName → PDF complete"
    } else {
        Write-Warning "❌ Failed to generate: $cleanName"
    }
}
