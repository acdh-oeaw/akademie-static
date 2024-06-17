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
            <body class="d-flex flex-column">
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

                            <div class="col-2">
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
                            <div class="col-8">
                                <h2 style="text-align: center;">
                                    <xsl:value-of select="$doc_title"/>
                                </h2>
                                <h3 style="text-align: center;">

                                    <div id="editor-widget">
                                        <xsl:call-template name="annotation-options"></xsl:call-template>
                                    </div>
                                    <a href="{$teiSource}">
                                        <i class="bi bi-filetype-xml" title="TEI/XML"/>
                                    </a>
                                </h3>
                            </div>
                            <div class="col-2" style="text-align:right">
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
                        </div>
                        <!-- badge for A protocols-->
                        <xsl:if test="starts-with(.//tei:titleStmt/tei:title[1]/text(), 'A_')">
                            <div class="row">
                             <div class="col-12 text-center">
                               <span class="badge text-bg-warning text-wrap">Hinweis: Diese Transkription wurde maschinell erstellt und nicht überprüft.</span>
                            </div>
                            </div>
                        </xsl:if>
                        <div id="container-resize" class="row transcript">

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
                                    <xsl:for-each select="tei:body//tei:note[not(./tei:p)]">
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
                <script src="https://unpkg.com/de-micro-editor@0.4.0/dist/de-editor.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.0/openseadragon.min.js"/>
                <script type="text/javascript" src="js/run.js"></script>
                <script type="text/javascript" src="js/osd_scroll.js"></script>

            </body>
        </html>
    </xsl:template>


    <xsl:template match="tei:p">
        <xsl:choose>
            <!-- add additional class for p elements that should be centered-->
            <xsl:when test="@rendition='#fc'">
                <p id="{local:makeId(.)}" class="fc yes-index paragraph-main-text">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p id="{local:makeId(.)}" class="yes-index paragraph-main-text">
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- template to make header text in the transcription bold -->
    <xsl:template match="tei:p[@rendition='#fc']/text()">
        <xsl:analyze-string select="." regex="Kaiserliche Akademie der Wissenschaften.|Protokoll">
            <xsl:matching-substring>
                <b>
                    <xsl:value-of select="."/>
                </b>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
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
            <xsl:attribute name="id" select="tei:pb/@xml:id"/>
            <xsl:apply-templates select="child::tei:pb"/>
            <xsl:apply-templates select="child::tei:div"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:pb">
        <xsl:variable name="oldUrl" select="key('surface-by-id', substring-after(@facs, '#'))//tei:graphic/@url" />
        <xsl:variable name="tokens" select="tokenize($oldUrl, '/')" />
        <xsl:variable name="series" select="$tokens[4]" />
        <xsl:variable name="fileName" select="$tokens[last()]" />
        <xsl:variable name="newUrl" select="concat('https://iiif.acdh.oeaw.ac.at/iiif/images/akademieprotokolle/', $series, '/', $fileName, '.jp2/full/max/0/default.jpg')" />
        <span class="pb" source="{$newUrl}"></span>
        <xsl:element name="p">
            <xsl:attribute name="class" select="'paragraph-for-page-break'"/>
            <xsl:text>Seite </xsl:text>
            <xsl:number level="any" count="tei:pb"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:div[parent::tei:div[@type = 'page']]">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="tei:lb">
        <xsl:element name="br" />
    </xsl:template>



    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="@rend='super'">
                <sup>
                    <xsl:apply-templates/>
                </sup>
            </xsl:when>
            <xsl:when test="@rend='strike'">
                <strike>
                    <xsl:apply-templates/>
                </strike>
            </xsl:when>
            <xsl:when test="not(@rend)">
                <u>
                    <xsl:apply-templates/>
                </u>
            </xsl:when>
            <xsl:otherwise>
                <!-- Do nothing -->
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="tei:choice">
        <span class="choice">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:choice/tei:abbr">
        <span class="abbr">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:choice/tei:expan">
        <span class="expan">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:choice/*[not(self::tei:abbr or self::tei:expan)]">
        <span class="other">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

</xsl:stylesheet>
