<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:template match="/" name="html_footer">
        <footer class="footer mt-auto py-3 bg-body-tertiary">
            <div class="wrapper" id="wrapper-footer-full">
                <div class="container" id="footer-full-content" tabindex="-1">
                    <div class="footer-separator">
                        CONTACT
                    </div>
                    <div class="row">
                        <div class="footer-widget col-lg-1 col-md-2 col-sm-2 col-xs-6  ml-auto text-center ">
                            <div class="textwidget custom-html-widget py-2"><a href="https://www.oeaw.ac.at/acdh"><img src="https://fundament.acdh.oeaw.ac.at/common-assets/images/acdh_logo.svg" class="image" alt="ACDH Logo" style="max-width: 100%; height: auto;" title="ACDH Logo"/></a></div>
                        </div>
                        <div class="footer-widget col-lg-4 col-md-3 col-sm-3">
                            <div class="textwidget custom-html-widget">
                                <p class="py-2">
                                    ACDH-CH OEAW
                                    <br></br>
                                        Austrian Centre for Digital Humanities and Cultural Heritage
                                        <br></br>
                                            Austrian Academy of Sciences
                                </p>
                                <p class="py-2">
                                    Bäckerstraße 13
                                    <br></br>
                                        1010 Vienna
                                </p>
                                <p class="py-2 link-in-footer">
                                    T: +43 1 51581-2200
                                    <br></br>
                                        E: <a href="mailto:acdh-ch-helpdesk@oeaw.ac.at">acdh-ch-helpdesk@oeaw.ac.at</a></p>
                            </div>
                        </div>
                        <div class="footer-widget col-lg-4 col-md-3 col-sm-4">
                            <div><img src="/akademie-static/images/oaw.png" class="image" alt="OEAW Logo" style="margin: 5pt;"></img></div>
                            <div><img src="/akademie-static/images/wienkultur.png" class="image" alt="Wien Kultur Logo" style="margin: 5pt;"></img></div>
                        </div>
                        <div class="footer-widget col-lg-3 col-md-4 col-sm-3 ml-auto">
                            <div class="row gy-2">
                                <div class="textwidget custom-html-widget">
                                    <h6 class="py-2 font-weight-bold">HELPDESK</h6>
                                    <p class="py-2">ACDH-CH runs a helpdesk offering advice for questions related to various digital humanities
                                        topics.</p>
                                    <p class="py-2"><a class="helpdesk-button" href="mailto:acdh-ch-helpdesk@oeaw.ac.at">ASK US!</a></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="float-end me-3">
                <a href="{$github_url}"><i class="bi bi-github"></i></a>
            </div>
        </footer>
        <script src="https://code.jquery.com/jquery-3.6.3.min.js" integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    </xsl:template>
</xsl:stylesheet>