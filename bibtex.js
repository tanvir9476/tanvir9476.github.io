(function () {
  const bibliographyPath = 'data/publications.bib';
  let bibliographyPromise;

  function loadBibliography() {
    if (!bibliographyPromise) {
      bibliographyPromise = fetch(bibliographyPath, { cache: 'no-cache' })
        .then(function (response) {
          if (!response.ok) {
            throw new Error('Unable to load the bibliography.');
          }

          return response.text();
        })
        .catch(function (error) {
          bibliographyPromise = undefined;
          throw error;
        });
    }

    return bibliographyPromise;
  }

  function isEscaped(source, index) {
    let slashCount = 0;

    for (let i = index - 1; i >= 0 && source[i] === '\\'; i -= 1) {
      slashCount += 1;
    }

    return slashCount % 2 === 1;
  }

  function extractEntry(source, requestedKey) {
    const entryPattern = /^[ \t]*@[a-zA-Z]+\s*\{/gm;
    let match;

    while ((match = entryPattern.exec(source)) !== null) {
      const entryStart = source.indexOf('@', match.index);
      const openingBrace = source.indexOf('{', entryStart);
      const keyEnd = source.indexOf(',', openingBrace + 1);

      if (openingBrace === -1 || keyEnd === -1) {
        return null;
      }

      const entryKey = source.slice(openingBrace + 1, keyEnd).trim();
      let depth = 0;
      let entryEnd = -1;

      for (let i = openingBrace; i < source.length; i += 1) {
        if (isEscaped(source, i)) {
          continue;
        }

        if (source[i] === '{') {
          depth += 1;
        } else if (source[i] === '}') {
          depth -= 1;

          if (depth === 0) {
            entryEnd = i + 1;
            break;
          }
        }
      }

      if (entryEnd === -1) {
        return null;
      }

      if (entryKey === requestedKey) {
        return source.slice(entryStart, entryEnd).trim();
      }

      entryPattern.lastIndex = entryEnd;
    }

    return null;
  }

  function fallbackCopy(text) {
    const textArea = document.createElement('textarea');
    textArea.value = text;
    textArea.setAttribute('readonly', '');
    textArea.style.position = 'fixed';
    textArea.style.opacity = '0';
    document.body.appendChild(textArea);
    textArea.select();

    const copied = document.execCommand('copy');
    textArea.remove();

    if (!copied) {
      throw new Error('Unable to copy the citation.');
    }
  }

  function copyCitation(text, button) {
    const copyPromise = navigator.clipboard && window.isSecureContext
      ? navigator.clipboard.writeText(text)
      : Promise.resolve().then(function () {
          fallbackCopy(text);
        });

    copyPromise
      .then(function () {
        button.textContent = 'Copied';
      })
      .catch(function () {
        button.textContent = 'Copy failed';
      })
      .finally(function () {
        window.setTimeout(function () {
          button.textContent = 'Copy';
        }, 1600);
      });
  }

  function renderCitation(panel, citation) {
    const toolbar = document.createElement('div');
    toolbar.className = 'bibtex-toolbar';

    const label = document.createElement('span');
    label.className = 'bibtex-label';
    label.textContent = 'BibTeX citation';

    const copyButton = document.createElement('button');
    copyButton.type = 'button';
    copyButton.className = 'bibtex-copy';
    copyButton.textContent = 'Copy';
    copyButton.setAttribute('aria-label', 'Copy BibTeX citation');
    copyButton.addEventListener('click', function () {
      copyCitation(citation, copyButton);
    });

    const citationText = document.createElement('pre');
    citationText.textContent = citation;

    toolbar.append(label, copyButton);
    panel.replaceChildren(toolbar, citationText);
    panel.dataset.loaded = 'true';
  }

  function renderError(panel) {
    const message = document.createElement('p');
    message.className = 'bibtex-error';
    message.append('Citation unavailable. ');

    const fullBibliographyLink = document.createElement('a');
    fullBibliographyLink.href = bibliographyPath;
    fullBibliographyLink.textContent = 'Open the complete BibTeX file.';
    message.appendChild(fullBibliographyLink);

    panel.replaceChildren(message);
  }

  document.querySelectorAll('.bibtex-toggle').forEach(function (toggle) {
    toggle.addEventListener('click', function (event) {
      event.preventDefault();

      const panel = document.getElementById(toggle.getAttribute('aria-controls'));
      const isOpen = toggle.getAttribute('aria-expanded') === 'true';

      if (!panel) {
        window.location.href = toggle.href;
        return;
      }

      toggle.setAttribute('aria-expanded', String(!isOpen));
      panel.hidden = isOpen;

      if (isOpen || panel.dataset.loaded === 'true') {
        return;
      }

      panel.textContent = 'Loading citation...';

      loadBibliography()
        .then(function (source) {
          const citation = extractEntry(source, toggle.dataset.bibtexKey);

          if (!citation) {
            throw new Error('Citation entry not found.');
          }

          renderCitation(panel, citation);
        })
        .catch(function () {
          renderError(panel);
        });
    });
  });
})();
