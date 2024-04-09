<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar" version="2.0" exclude-result-prefixes="xsl tei xs local">

    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>


    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/aot-options.xsl"/>

    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
    </xsl:variable>
    <xsl:key name="surface-by-id" match="tei:facsimile/tei:surface" use="@xml:id"/>

    <xsl:template match="/">


        <html class="h-100">

            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <!-- 
                <style>
                    .navBarNavDropdown ul li:nth-child(2) {
                        display: none !important;
                    }
                </style>
                -->
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0">
                    <div class="container">


                        <div class="row">
                            <div class="col-md-2 col-lg-2 col-sm-12"/>
                            <div class="col-md-8 col-lg-8 col-sm-12">
                                <h1 style="text-align: center;">
                                    <xsl:apply-templates select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:meeting"/>
                                </h1>
                            </div>
                            <div class="col-md-2 col-lg-2 col-sm-12" style="text-align: right;"/>
                        </div>

                        <div class="row">

                            <div class="col-md-2 col-lg-2 col-sm-12">
                                <xsl:if test="ends-with($prev,'.html')">
                                    <h1>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$prev"/>
                                            </xsl:attribute>
                                            <i class="bi bi-chevron-left" title="zurück"/>
                                        </a>
                                    </h1>
                                </xsl:if>
                            </div>
                            <div class="col-md-8 col-lg-8 col-sm-12">
                                <h2 style="text-align: center;">
                                    <xsl:value-of select="$doc_title"/>
                                </h2>
                                <h3 style="text-align: center;">
                                    <a href="{$teiSource}">
                                        <i class="bi bi-download" title="TEI/XML"/>
                                    </a>
                                </h3>
                            </div>
                            <div class="col-md-2 col-lg-2 col-sm-12" style="text-align:right">
                                <xsl:if test="ends-with($next, '.html')">
                                    <h1>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$next"/>
                                            </xsl:attribute>
                                            <i class="bi bi-chevron-right" title="weiter"/>
                                        </a>
                                    </h1>
                                </xsl:if>
                            </div>
                            <div id="editor-widget">
                                <xsl:call-template name="annotation-options"></xsl:call-template>
                            </div>
                        </div>
                        <div class="row">
                            <div id="img-resize" class="col-md-6 col-lg-6 col-sm-12 facsimiles">
                                <div id="viewer">
                                    <div id="container_facs_1">
                                        <!-- container and facs handling in js -->
                                    </div>
                                </div>
                            </div>
                            <div id="text-resize" lang="de" class="col-md-6 col-lg-6 col-sm-12 text yes-index">
                                <xsl:apply-templates select=".//tei:body"></xsl:apply-templates>


                                <p style="text-align:center;">
                                    <xsl:for-each select=".//tei:note[not(./tei:p)]">
                                        <div class="footnotes" id="{local:makeId(.)}">
                                            <xsl:element name="a">
                                                <xsl:attribute name="name">
                                                    <xsl:text>fn</xsl:text>
                                                    <xsl:number level="any" format="1" count="tei:note"/>
                                                </xsl:attribute>
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:text>#fna_</xsl:text>
                                                        <xsl:number level="any" format="1" count="tei:note"/>
                                                    </xsl:attribute>
                                                    <span style="font-size:7pt;vertical-align:super; margin-right: 0.4em">
                                                        <xsl:number level="any" format="1" count="tei:note"/>
                                                    </span>
                                                </a>
                                            </xsl:element>
                                            <xsl:apply-templates/>
                                        </div>
                                    </xsl:for-each>
                                </p>
                            </div>
                        </div>
                    </div>
                    <xsl:for-each select="//tei:back">
                        <div class="tei-back">
                            <xsl:apply-templates/>
                        </div>
                    </xsl:for-each>
                </main>
                <xsl:call-template name="html_footer"/>
                <script src="https://unpkg.com/de-micro-editor@0.3.4/dist/de-editor.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.0/openseadragon.min.js"/>
                <script type="text/javascript" src="js/run.js"></script>
                <script type="text/javascript" src="js/osd_scroll.js"></script>

            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:p">
        <p id="{local:makeId(.)}" class="yes-index paragraph-main-text">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:div">
        <div id="{local:makeId(.)}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:date">
        <xsl:value-of select="text()"/>
    </xsl:template>

    <xsl:template match="tei:body">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:div[@type = 'page']">
        <xsl:element name="div">
            <xsl:attribute name="class" select="'make-box-for-page'"/>
            <xsl:apply-templates select="child::tei:pb"/>
            <xsl:apply-templates select="child::tei:div"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:pb">
        <!-- add /full/full/0/default.jpg to each image url based on Bundesverfassung Österreich -->
        <span class="pb" source="{concat(key('surface-by-id', substring-after(@facs, '#'))//tei:graphic/@url, '/full/full/0/default.jpg')}"></span>
        <xsl:element name="p">
            <xsl:attribute name="class" select="'paragraph-for-page-break'"/>
            <xsl:text>Seite </xsl:text>
            <xsl:value-of select="@n"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:div[parent::tei:div[@type = 'page']]">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:lb">
        <xsl:text> | </xsl:text>
    </xsl:template>


</xsl:stylesheet>
