
# encode-frontend-transformation

[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](LICENSE)

> **Part of the “Front-End Data Processing and Visualization for Digital Scholarship” lecture**  
> **Date:** May 23, 2025  
> **Context:** This module is one component of the Erasmus+ BIP Intensive ENCODE: Digital Competences in Ancient Writing Cultures Spring School Program.

---

## Overview

This repository provides two XSLT 2.0 stylesheets to convert TEI-encoded EpiDoc XML inscriptions into clean, responsive HTML5 for web visualization. It was developed for the Front-End Data Processing and Visualization lecture (May 23, 2025) at the University of Parma, Italy, within the Erasmus+ BIP Intensive ENCODE week (May 18–24, 2025).

---
## Repository Structure


```

encode-epidoc-transform/  
├── tei2html_bootstrap.xsl # Bootstrap-based HTML5 output  
├── tei2html_tailwind.xsl # TailwindCSS-based HTML5 output  
├── samples/ # Example EpiDoc XML inputs  
│ └── sample-inscription.xml  
├── LICENSE  
└── README.md

```

---

##  Quick Start

1. **Clone the repo** (optional if you only need the XSLTs):  
   ```bash
   git clone https://github.com/unipr/encode-epidoc-transform.git
   cd encode-epidoc-transform

2.  **Open** [http://xsltransform.net/](http://xsltransform.net/) in your browser.
    
3.  **Load files**
    
    -   **XML panel:** Paste your EpiDoc XML.
        
    -   **XSLT panel:** Paste either `tei2html_bootstrap.xsl` or `tei2html_tailwind.xsl`.
        
4.  **Transform** by clicking **“Transform”**.
    
    -   The **Result** panel shows your HTML, styled with Bootstrap 5 or TailwindCSS.
        
5.  **Save** the generated `.html` and open in any modern browser to inspect.
    

----------

## Stylesheets

### 1. `tei2html_bootstrap.xsl`

-   Strips ignorable whitespace, preserves TEI edition spacing
    
-   Renders TEI elements (`<choice>`, `<note>`, `<gap>`, etc.) into HTML spans
    
-   Generates a [Bootstrap](https://getbootstrap.com/)-styled header, metadata card, facsimile gallery, edition, apparatus, translation, and bibliography
    

### 2. `tei2html_tailwind.xsl`

-   Same core TEI → HTML transformation logic
    
-   Uses [TailwindCSS](https://tailwindcss.com/) utility classes (`prose`, grid layouts, cards)
    
-   Includes Google Fonts for typography
    

----------

##  Workshop Exercises

During the May 23 lecture, you will:

1.  **Basic Transformation**: Convert an inscription encoded in XML into HTML.
    
2.  **Edition Formatting**: Preserve line breaks and apparatus in `<pre>` blocks.
    
3.  **Metadata Rendering**: Map TEI header fields into styled cards.
    
4.  **Image Gallery**: Loop over `<facsimile>` to build a responsive gallery.
    
5.  **Custom Tweaks**: Experiment with additional CSS or interactive scripts.
    

    ----------

##  License

This material is released under **CC BY 4.0**.  
See [LICENSE](https://chatgpt.com/c/LICENSE) for full details.

----------

##  Acknowledgments

-   Erasmus+ BIP Intensive ENCODE: Digital Competences in Ancient Writing Cultures
    
-   University of Parma, Department of Classical Philology and Italian Studies
      

----------

> **Tip:** If you encounter parsing errors, verify that your XML declares  
> `xmlns:tei="http://www.tei-c.org/ns/1.0"` and that you’re using an XSLT 2.0–capable processor such as [Saxon](https://www.saxonica.com/welcome/welcome.xml) or the online [xsltransform.net](http://xsltransform.net/).
