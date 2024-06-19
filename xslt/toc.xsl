<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar" version="2.0" exclude-result-prefixes="xsl tei xs local">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes" />
    <xsl:import href="partials/html_navbar.xsl" />
    <xsl:import href="partials/html_head.xsl" />
    <xsl:import href="partials/html_footer.xsl" />
    <xsl:import href="partials/tabulator_dl_buttons.xsl" />
    <xsl:import href="partials/tabulator_js.xsl" />
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Inhaltsverzeichnis'" />
        <html class="h-100">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title" />
                </xsl:call-template>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar" />
                <main>
                    <div class="container" style="margin-bottom: 5rem;">
                        <h1>Inhaltsverzeichnis</h1>
                        <table class="table" id="myTable">
                            <thead>
                                <tr>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-minWidth="110">Signatur</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-minWidth="110">Sitzung</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-minWidth="110">Datum</th>
                                    <th scope="col" tabulator-visible="false">Sitzungsrahmen</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="collection('../data/editions?select=*.xml')//tei:TEI">
                                    <xsl:variable name="full_path">
                                        <xsl:value-of select="document-uri(/)" />
                                    </xsl:variable>
                                    <tr>
                                        <td>
                                            <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()" />
                                        </td>
                                        <td>
                                            <xsl:value-of select=".//tei:titleStmt/tei:meeting/text()"/>
                                            <xsl:value-of select=".//tei:titleStmt/tei:meeting/tei:date/text()"/>

                                        </td>
                                        <td>
                                            <xsl:value-of select=".//tei:titleStmt/tei:meeting/tei:date/@when" />
                                        </td>
                                        <td>
                                            <xsl:choose>
                                                <xsl:when test="starts-with(.//tei:titleStmt/tei:title[1]/text(), 'A')">
                                                    <xsl:text>Gesamtakademie</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="starts-with(.//tei:titleStmt/tei:title[1]/text(), 'C')">
                                                    <xsl:text>phil.-hist. Klasse</xsl:text>
                                                </xsl:when>
                                                <!-- placeholder for other cases-->
                                                <xsl:otherwise>
                                                    <xsl:text>Unbekannt</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                        <xsl:call-template name="tabulator_dl_buttons" />
                    </div>
                </main>
                <xsl:call-template name="html_footer" />
                <xsl:call-template name="tabulator_js">
                    <xsl:with-param name="sortColumn" select="'signatur'"/>
                    <xsl:with-param name="groupConfig" select="'true'"/>
                </xsl:call-template>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>