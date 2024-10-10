<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:template match="/" name="html_footer">
        <footer class="footer mt-auto py-3 bg-body-tertiary">
            <div class="wrapper" id="wrapper-footer-full">
                <div class="container" id="footer-full-content" tabindex="-1">
                    <div class="footer-separator">
                        KONTAKT
                    </div>
                    <div class="row">
                        <!-- ACDH Logo and Link -->
                        <div class="col-lg-2 col-md-4 col-sm-6 text-center my-2">
                            <a href="https://www.oeaw.ac.at/acdh">
                                <img src="images/ACDHCH_logo.png" class="img-fluid" alt="ACDH Logo" title="ACDH Logo"/>
                            </a>
                        </div>

                        <!-- Address and Contact Info -->
                        <div class="col-lg-4 col-md-4 col-sm-6 my-2">
                            <p>ACDH-CH OEAW <br/>
                Austrian Centre for Digital Humanities and Cultural Heritage<br/>
                Österreichische Akademie der Wissenschaften </p>
                        <p>Bäckerstraße 13, 1010 Wien</p>
                        <p>T: +43 1 51581-2200 <br/>
                E: <a href="mailto:acdh-ch-helpdesk@oeaw.ac.at">acdh-ch-helpdesk@oeaw.ac.at</a>
                    </p>
                </div>

                <!-- OEAW and Wien Kultur Logos -->
                <div class="col-lg-3 col-md-4 col-sm-6 my-2">
                    <img src="images/oaw.png" class="img-fluid mb-2" alt="OEAW Logo"/>
                    <img src="images/wienkultur.png" class="img-fluid" alt="Wien Kultur Logo"/>
                </div>

                <!-- Helpdesk Info -->
                <div class="col-lg-3 col-md-4 col-sm-6 my-2">
                    <h6 class="font-weight-bold">HELPDESK</h6>
                    <p>ACDH-CH betreibt einen Helpdesk, an den Sie gerne Ihre Fragen zu Digitalen Geisteswissenschaften stellen dürfen.</p>
                    <p>
                        <a class="helpdesk-button" href="mailto:acdh-ch-helpdesk@oeaw.ac.at">FRAGEN SIE UNS!</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
    <div class="float-end me-3">
        <a href="{$github_url}">
            <i class="bi bi-github" aria-hidden="true"></i>
            <span class="visually-hidden">GitHub Repository</span>
        </a>
    </div>
</footer>
<script src="https://code.jquery.com/jquery-3.6.3.min.js" integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</xsl:template>
</xsl:stylesheet>