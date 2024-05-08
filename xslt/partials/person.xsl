<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" exclude-result-prefixes="xsl tei xs">

    <xsl:template match="tei:person" name="person_detail">
        <table class="table entity-table">
            <tbody>
                <xsl:if test="./tei:birth/text()">
                    <tr>
                        <th>
                        Geburtsdatum
                        </th>
                        <td>
                            <xsl:value-of select="./tei:birth/text()"/>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="./tei:birth/tei:place/tei:placeName">
                    <tr>
                        <th>
                        Geburtsort
                        </th>
                        <td>
                            <xsl:value-of select="(./tei:birth/tei:place/tei:placeName/text())[1]"/>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="./tei:death/text()">
                    <tr>
                        <th>
                        Sterbedatum
                        </th>
                        <td>
                            <xsl:value-of select="./tei:death/text()"/>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="./tei:death/tei:place/tei:placeName">
                    <tr>
                        <th>
                        Sterbeort
                        </th>
                        <td>
                            <xsl:value-of select="(./tei:death/tei:place/tei:placeName/text())[1]"/>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="./tei:occupation/text()">
                    <tr>
                        <th>
                        Beruf
                        </th>
                        <td>
                            <xsl:for-each select="./tei:occupation/text()">
                                <xsl:if test="position() != 1"> / </xsl:if>
                                <xsl:value-of select="."/>
                            </xsl:for-each>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="./tei:idno[@subtype='GND']/text()">
                    <tr>
                        <th>
                            GND ID
                        </th>
                        <td>
                            <a href="{./tei:idno[@subtype='GND']}" target="_blank">
                                <xsl:value-of select="tokenize(./tei:idno[@subtype='GND'], '/')[last()]"/>
                            </a>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="./tei:idno[@type='WIKIDATA']/text()">
                    <tr>
                        <th>
                            Wikidata ID
                        </th>
                        <td>
                            <a href="{./tei:idno[@type='WIKIDATA']}" target="_blank">
                                <xsl:value-of select="tokenize(./tei:idno[@type='WIKIDATA'], '/')[last()]"/>
                            </a>
                        </td>
                    </tr>
                </xsl:if>
               
                <xsl:if test="./tei:noteGrp">
                    <tr>
                        <th>
                        Erwähnt in
                        </th>
                        <td>
                            <ul>
                                <xsl:for-each select="./tei:noteGrp/tei:note">
                                    <li>
                                        <a href="{replace(@target, '.xml', '.html')}">
                                            <xsl:value-of select="./text()"/>
                                        </a>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </td>
                    </tr>
                </xsl:if>
            </tbody>
        </table>
    </xsl:template>
</xsl:stylesheet>