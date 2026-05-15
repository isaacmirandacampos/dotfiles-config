#!/bin/bash
# Markdown preview with client-side Mermaid rendering
RAW="${1/#\~/$HOME}"
if [[ "$RAW" = /* ]]; then
  INPUT="$RAW"
else
  INPUT="$(pwd)/$RAW"
fi
INPUT="$(realpath "$INPUT")"
OUTPUT="/tmp/md-preview-$(basename "$INPUT" .md).html"

pandoc "$INPUT" \
  --from gfm \
  --standalone \
  --metadata title="$(basename "$INPUT")" \
  --include-in-header=<(cat <<'HTML'
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/github-markdown-css@5/github-markdown.min.css">
<style>
  body {
    background: #0d1117 !important;
    max-width: none !important;
    padding: 2rem !important;
    display: flex; justify-content: center;
  }
  .markdown-body {
    box-sizing: border-box;
    min-width: 200px; max-width: 1400px; width: 100%;
    padding: 2rem 4rem;
  }
  .mermaid-wrapper { position: relative; background: #fff; border-radius: 8px; padding: 1rem; }
  .mermaid-expand {
    position: absolute; top: 4px; right: 4px;
    background: #24292e; color: #fff; border: none; border-radius: 4px;
    padding: 4px 8px; cursor: pointer; font-size: 14px; opacity: 0;
    transition: opacity .2s;
  }
  .mermaid-wrapper:hover .mermaid-expand { opacity: .8; }
  .mermaid-expand:hover { opacity: 1 !important; }
  .mermaid-modal {
    display: none; position: fixed; inset: 0; z-index: 9999;
    background: rgba(0,0,0,.85); justify-content: center; align-items: center;
    cursor: zoom-out;
  }
  .mermaid-modal.open { display: flex; }
  .mermaid-modal-content {
    width: 85vw; height: 80vh; overflow: auto;
    background: #fff; border-radius: 8px; padding: 2rem;
    display: flex; justify-content: center; align-items: center;
  }
  .mermaid-modal-content svg { max-width: 100%; max-height: 100%; }
  .markdown-body a { color: #58a6ff; text-decoration: underline; }
  .markdown-body a:hover { color: #79c0ff; }
</style>
HTML
) \
  --include-before-body=<(echo '<article class="markdown-body">') \
  --include-after-body=<(cat <<'HTML'
</article>
<div class="mermaid-modal" id="mermaid-modal">
  <div class="mermaid-modal-content" id="mermaid-modal-content"></div>
</div>
<script type="module">
  import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';
  mermaid.initialize({ startOnLoad: false });

  document.querySelectorAll('.markdown-body a').forEach(a => {
    a.setAttribute('target', '_blank');
    a.setAttribute('rel', 'noopener');
  });

  document.querySelectorAll('pre.mermaid').forEach(pre => {
    const code = pre.querySelector('code');
    const div = document.createElement('div');
    div.classList.add('mermaid');
    div.textContent = code ? code.textContent : pre.textContent;
    pre.replaceWith(div);
  });

  await mermaid.run();

  const modal = document.getElementById('mermaid-modal');
  const modalContent = document.getElementById('mermaid-modal-content');

  document.querySelectorAll('.mermaid').forEach(div => {
    const wrapper = document.createElement('div');
    wrapper.classList.add('mermaid-wrapper');
    div.parentNode.insertBefore(wrapper, div);
    wrapper.appendChild(div);

    const btn = document.createElement('button');
    btn.classList.add('mermaid-expand');
    btn.textContent = '\u26F6';
    btn.title = 'Expandir diagrama';
    wrapper.appendChild(btn);

    btn.addEventListener('click', () => {
      modalContent.innerHTML = div.innerHTML;
      modal.classList.add('open');
    });
  });

  modal.addEventListener('click', (e) => {
    if (e.target === modal) modal.classList.remove('open');
  });
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') modal.classList.remove('open');
  });
</script>
HTML
) \
  -o "$OUTPUT"

open "$OUTPUT"
