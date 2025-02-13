<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                version="2.0"
                exclude-result-prefixes="xsl tei xs">
    <xsl:template match="tei:person"
                  name="person_detail">
        <table class="table person-table">
            <tbody>
                <xsl:variable name="birth"
                              select="./tei:birth" />
                <xsl:variable name="death"
                              select="./tei:death" />
                <xsl:if test="./tei:persName/tei:addName/text()">
                    <tr>
                        <th>                            
                            Namenszusätze
                        </th>
                        <td>
                            <xsl:for-each select="./tei:persName/tei:addName/text()">
                                <xsl:if test="position() != 1"> / </xsl:if>
                                <xsl:value-of select="." />
                            </xsl:for-each>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:variable name="birthDate"
                              select="$birth/tei:date/text()" />
                <xsl:if test="$birthDate">
                    <tr>
                        <th>                            
                            Geburtsdatum
                        </th>
                        <td>
                            <xsl:value-of select="$birthDate" />
                        </td>
                    </tr>
                </xsl:if>
                <xsl:variable name="birthPlace"
                              select="($birth/tei:placeName/text())[1]" />
                <xsl:if test="$birthPlace">
                    <tr>
                        <th>                            
                            Geburtsort
                        </th>
                        <td>
                            <xsl:value-of select="$birthPlace" />
                        </td>
                    </tr>
                </xsl:if>
                <xsl:variable name="deathDate"
                              select="$death/tei:date/text()" />
                <xsl:if test="$deathDate">
                    <tr>
                        <th>                            
                            Sterbedatum
                        </th>
                        <td>
                            <xsl:value-of select="$deathDate" />
                        </td>
                    </tr>
                </xsl:if>
                <xsl:variable name="deathPlace"
                              select="($death/tei:placeName/text())[1]" />
                <xsl:if test="$deathPlace">
                    <tr>
                        <th>                            
                            Sterbeort
                        </th>
                        <td>
                            <xsl:value-of select="$deathPlace" />
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
                                <xsl:value-of select="." />
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
                            <a href="{./tei:idno[@subtype='GND']}"
                               target="_blank">
                                <xsl:value-of select="tokenize(./tei:idno[@subtype='GND'], '/')[last()]" />
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
                            <a href="{./tei:idno[@type='WIKIDATA']}"
                               target="_blank">
                                <xsl:value-of select="tokenize(./tei:idno[@type='WIKIDATA'], '/')[last()]" />
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
                            <div id="mentions">
                                <xsl:text disable-output-escaping="yes">&lt;script&gt;</xsl:text>                                    
                                    var mentions = [
                                <xsl:for-each select="./tei:noteGrp/tei:note">
                                    <xsl:variable name="targetDoc"
                                                  select="document(concat('../../data/editions/', @target))" />
                                    <xsl:text>{</xsl:text>
                                    <xsl:text>"protocol": "</xsl:text>
                                    <xsl:value-of select="concat(normalize-space(($targetDoc//tei:titleStmt/tei:meeting/text())[1]), ' ', normalize-space($targetDoc//tei:titleStmt/tei:meeting/tei:date/text()))" />
                                    <xsl:text>",</xsl:text>
                                    <xsl:text>"target": "</xsl:text>
                                    <xsl:value-of select="replace(@target, '.xml', '.html')" />
                                    <xsl:text>",</xsl:text>
                                    <xsl:text>}</xsl:text>
                                    <xsl:if test="position() != last()">,</xsl:if>
                                </xsl:for-each>                                    
                                    ];
                                <xsl:text disable-output-escaping="yes">&lt;/script&gt;</xsl:text>
                            </div>
                        </td>
                    </tr>
                </xsl:if>
            </tbody>
        </table>
    </xsl:template>
</xsl:stylesheet>