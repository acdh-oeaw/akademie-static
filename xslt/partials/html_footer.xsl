<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:template match="/" name="html_footer">
        <footer class="footer mt-auto py-4 bg-body-tertiary border-top">
            <div class="container" id="footer-full-content" tabindex="-1">
                <div class="row g-4 justify-content-between">
                    <!-- 1. ACDH Logo + Contact -->
                    <div class="col-12 col-md-6 col-lg-4">
                        <div class="d-flex flex-column flex-sm-row gap-3 align-items-center">
                            <a href="https://www.oeaw.ac.at/acdh" class="flex-shrink-0">
                                <img src="images/ACDHCH_logo.png" class="img-fluid" alt="ACDH Logo" style="max-height:90px"/>
                                <span class="visually-hidden">Link zur ACDH OEAW Webseite</span>
                            </a>
                            <address class="mb-0 small">
                                <strong>ACDH OEAW</strong><br/>
                                Austrian Centre for Digital Humanities<br/>
                                Österreichische Akademie der Wissenschaften<br/>
                                Bäckerstraße 13, 1010 Wien<br/>
                                T: +43 1 51581-2200<br/>
                                E: <a href="mailto:acdh-helpdesk@oeaw.ac.at">acdh-helpdesk@oeaw.ac.at</a>
                            </address>
                        </div>
                    </div>

                    <!-- 2. Partner Logos -->
                    <div class="col-12 col-md-6 col-lg-4">
                        <div class="d-flex flex-row flex-md-column gap-4 align-items-center justify-content-center h-100">
                            <img src="images/oaw.png" class="img-fluid" alt="ÖAW Logo" style="max-height:90px; width:150px; object-fit:contain"/>
                            <img src="images/wienkultur.png" class="img-fluid" alt="Wien Kultur Logo" style="max-height:90px; width:150px; object-fit:contain"/>
                        </div>
                    </div>

                    <!-- 3. Helpdesk -->
                    <div class="col-12 col-md-12 col-lg-4">
                        <div class="d-flex flex-column h-100">
                            <h6 class="fw-semibold mb-2">Helpdesk</h6>
                            <p class="small mb-3">ACDH betreibt einen Helpdesk, an den Sie gerne Ihre Fragen zu Digitalen Geisteswissenschaften stellen dürfen.</p>
                            <div class="d-flex flex-wrap align-items-center gap-3">
                                <a class="btn btn-outline-primary btn-sm" href="mailto:acdh-helpdesk@oeaw.ac.at">Fragen Sie uns!</a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="text-center mt-3 pt-2 border-top">
                    <a href="{$github_url}" class="text-decoration-none">
                        <i class="bi bi-github fs-2" aria-hidden="true"></i>
                        <span class="visually-hidden">Link zum GitHub Repository</span>
                    </a>
                </div>
            </div>
        </footer>
        <script src="https://code.jquery.com/jquery-3.6.3.min.js" integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    </xsl:template>
</xsl:stylesheet>