<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:function name="local:makeId" as="xs:string">
        <xsl:param name="currentNode" as="node()"/>
        <xsl:variable name="nodeCurrNr">
            <xsl:value-of select="count($currentNode//preceding-sibling::*) + 1"/>
        </xsl:variable>
        <xsl:value-of select="concat(name($currentNode), '__', $nodeCurrNr)"/>
    </xsl:function>

    <xsl:template match="tei:pb" name="tei-pb">
        <xsl:variable name="graphic-id" select="data(substring-after(@facs, '#'))"/>
        <xsl:choose>
            <xsl:when test="starts-with(ancestor::tei:TEI/@xml:id, 'edoc_wd_')">
							<xsl:variable name="date" select="substring-after(ancestor::tei:TEI/@xml:id, 'edoc_wd_')"/>
							<xsl:variable name="img-fn" select="substring-after(ancestor::tei:TEI//tei:surface[@xml:id=$graphic-id]/tei:graphic[1]/@url, 'anno:')"/>
							<xsl:variable name="img-1" select="replace(replace(tokenize($img-fn, '_')[last()], '.jpg', ''), '.png', '')"/>
							<xsl:choose>
								<xsl:when test="starts-with($date, '1703') or starts-with($date, '1716') or starts-with($date, '1719') or starts-with($date, '1720') or starts-with($date, '1721')">
										<xsl:variable name="img-url" select="'digit__'"/>
										<xsl:variable name="graphic-url" select="concat($img-url, $img-1)"/>
										<div class="my-2 basis-full page_switch" id="wr_page_{@n}">
												<span class="anchor-pb"></span>
												<span class="pb text-gray-400" id="{$graphic-url}">-----[<xsl:value-of select="./@n"/>]-----</span>
										</div>
								</xsl:when>
								<xsl:otherwise>
										<xsl:variable name="img-url" select="'wrz|'"/>
										<xsl:variable name="filedate" select="substring-before($img-1, '-')"/>
										<!-- <xsl:variable name="img-dir1" select="tokenize($img-1, '-')[1]"/>
										<xsl:variable name="img-dir-year" select="tokenize($date, '-')[1]"/>
										<xsl:variable name="img-dir-month" select="tokenize($date, '-')[2]"/>
										<xsl:variable name="img-dir-day" select="tokenize($date, '-')[3]"/>
										<xsl:variable name="img-dir-yearx" select="concat(substring($img-dir-year, 1, 3), 'x')"/>
										<xsl:variable name="graphic-url" select="concat($img-url, $img-dir-yearx, '/', $img-dir-year, '/', $img-dir-month, '/', $img-dir1, '/', $img-1, '/full/full/0/default.jpg')"/> -->
										<xsl:variable name="graphic-url" select="concat($img-url, $filedate, '|', @n, '|99.9|0' )"/>
										<div class="my-2 basis-full page_switch" id="wr_page_{@n}">
												<span class="anchor-pb"></span>
												<span class="pb text-gray-400" id="{$graphic-url}">-----[<xsl:value-of select="./@n"/>]-----</span>
										</div>
								</xsl:otherwise>
							</xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!--<xsl:variable name="graphic-url" select="ancestor::tei:TEI//tei:surface[@xml:id=$graphic-id]/tei:graphic[starts-with(@url, 'http')]/@url"/>-->
                <xsl:variable name="anno-url" select="'wrz|'"/>
                <xsl:variable name="date" select="replace(substring-after(ancestor::tei:TEI/@xml:id, 'wr_'), '.xml', '')"/>
                <xsl:variable name="graphic-url" select="concat($anno-url, replace($date, '-', ''), '|', @n, '|99.9|0')"/>
                <div class="my-2 basis-full page_switch" id="wr_page_{@n}">
                    <span class="anchor-pb"></span>
                    <span class="pb text-gray-400" id="{$graphic-url}">-----[<xsl:value-of select="./@n"/>]-----</span>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:unclear">
        <abbr title="unclear"><xsl:apply-templates/></abbr>
    </xsl:template>
    <xsl:template match="tei:del">
        <del><xsl:apply-templates/></del>
    </xsl:template>
    <xsl:template match="tei:cit">
        <cite><xsl:apply-templates/></cite>
    </xsl:template>
    <xsl:template match="tei:quote">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:date">
        <span class="date"><xsl:apply-templates/></span>
    </xsl:template>
    <!-- <xsl:template match="tei:lb">
        <br/>
    </xsl:template> -->

    <xsl:template match="tei:note">
        <xsl:element name="a">
            <xsl:attribute name="id">
                <xsl:text>fna_</xsl:text>
                <xsl:number level="any" format="1" count="tei:note"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#fn</xsl:text>
                <xsl:number level="any" format="1" count="tei:note"/>
            </xsl:attribute>
            <xsl:attribute name="aria-label">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:attribute>
            <sup>
                <xsl:number level="any" format="1" count="tei:note"/>
            </sup>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:list">
        <div class="grid-item">
            <xsl:choose>
                <xsl:when test="ancestor::tei:body">
                    <xsl:if test="preceding-sibling::*[1]/name() = 'head'">
                        <xsl:for-each select="preceding-sibling::*[1]">
                            <h5 id="{local:makeId(.)}" class="yes-index text-center">
                                <xsl:apply-templates/>
                            </h5>
                        </xsl:for-each>
                    </xsl:if>
                    <ul class="yes-index">
                        <xsl:apply-templates/>
                    </ul>
                </xsl:when>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template match="tei:item">
        <xsl:choose>
            <xsl:when test="parent::tei:list[@type='unordered']|ancestor::tei:body">
                <li><xsl:apply-templates/></li>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:hi">
        <span>
            <xsl:choose>
                <xsl:when test="@rendition = '#em'">
                    <xsl:attribute name="class">
                        <xsl:text>italic</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@rendition = '#italic'">
                    <xsl:attribute name="class">
                        <xsl:text>italic</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@rendition = '#smallcaps'">
                    <xsl:attribute name="class">
                        <xsl:text>smallcaps</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@rendition = '#bold'">
                    <xsl:attribute name="class">
                        <xsl:text>bold</xsl:text>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:ref">
        <a class="ref {@type}" href="{@target}"><xsl:apply-templates/></a>
    </xsl:template>
    <xsl:template match="tei:lg">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    <xsl:template match="tei:l">
        <xsl:apply-templates/><br/>
    </xsl:template>
    <xsl:template match="tei:p">
       <p><xsl:apply-templates/></p>
    </xsl:template>

    <xsl:template match="tei:table">
        <div class="grid-item">
            <xsl:element name="table">
                <xsl:attribute name="class">
                    <xsl:text>table table-bordered table-striped table-condensed table-hover</xsl:text>
                </xsl:attribute>
                <xsl:element name="tbody">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:element>
        </div>
    </xsl:template>
    <xsl:template match="tei:row">
        <xsl:element name="tr">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:cell">
        <xsl:element name="td">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:rs">
        <xsl:variable name="id" select="@xml:id"/>
        <xsl:variable name="tokens" select="tokenize(@ref, ' ')"/>
        <xsl:variable name="rendition" select="substring-after(@rendition, '#')"/>
        <xsl:choose>
            <xsl:when test="count($tokens) > 1 and not(@prev)">
                <xsl:variable name="role" select="id(data(substring-after($tokens[1], '#')))/@role"/>
                <xsl:choose>
                    <xsl:when test="@type='person'">
                        <xsl:for-each select="$tokens">
                            <span class="persons entity {$rendition}" id="{$id}" data-bs-toggle="modal" data-bs-target="{.}">
                            </span>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="@type='place'">
                        <xsl:for-each select="$tokens">
                            <span class="places entity {$rendition}" id="{$id}" data-bs-toggle="modal" data-bs-target="{.}">
                            </span>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="@type='bibl'">
                        <xsl:for-each select="$tokens">
                            <span class="works entity {$rendition}" id="{$id}" data-bs-toggle="modal" data-bs-target="{.}">
                            </span>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="count($tokens) = 1 and not(@prev)">
                <xsl:choose>
                    <xsl:when test="@type='person'">
                        <xsl:variable name="role" select="id(data(substring-after(@ref, '#')))/@role"/>
                        <span class="persons entity {$rendition}" id="{$id}" data-bs-toggle="modal" data-bs-target="{@ref}">
                        </span>
                    </xsl:when>
                    <xsl:when test="@type='place'">
                        <span class="places entity {$rendition}" id="{$id}" data-bs-toggle="modal" data-bs-target="{@ref}">
                        </span>
                    </xsl:when>
                    <xsl:when test="@type='bibl'">
                        <span class="works entity {$rendition}" id="{$id}" data-bs-toggle="modal" data-bs-target="{@ref}">
                        </span>
                    </xsl:when>
                </xsl:choose>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@prev">
                <xsl:apply-templates/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:listPerson">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:person">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="5" />
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="modal fade" id="{@xml:id}" data-bs-keyboard="false" tabindex="-1" aria-labelledby="{concat(./tei:persName[1]/tei:surname[1], ', ', ./tei:persName[1]/tei:forename[1])}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel"><xsl:value-of select="concat(./tei:persName[1]/tei:surname[1], ', ', ./tei:persName[1]/tei:forename[1])"/></h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <table class="table">
                            <tbody>
                                <xsl:if test="./tei:idno[@type='GEONAMES']">
                                <tr>
                                    <th>
                                        Geonames ID
                                    </th>
                                    <td>
                                        <a href="{./tei:idno[@type='GEONAMES']}" target="_blank">
                                            <xsl:value-of select="tokenize(./tei:idno[@type='GEONAMES'], '/')[4]"/>
                                        </a>
                                    </td>
                                </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type='WIKIDATA']">
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
                                <xsl:if test="./tei:idno[@type='GND']">
                                <tr>
                                    <th>
                                        GND ID
                                    </th>
                                    <td>
                                        <a href="{./tei:idno[@type='GND']}" target="_blank">
                                            <xsl:value-of select="tokenize(./tei:idno[@type='GND'], '/')[last()]"/>
                                        </a>
                                    </td>
                                </tr>
                                </xsl:if>
                                <xsl:if test="./tei:listEvent">
                                <tr>
                                    <th>
                                        Erwähnungen
                                    </th>
                                    <td>
                                        <ul>
                                            <xsl:for-each select=".//tei:event">
                                                <xsl:variable name="linkToDocument">
                                                    <xsl:value-of select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')"/>
                                                </xsl:variable>
                                                <xsl:choose>
                                                    <xsl:when test="position() lt $showNumberOfMentions + 1">
                                                        <li>
                                                            <xsl:value-of select=".//tei:title"/><xsl:text> </xsl:text>
                                                            <a href="{$linkToDocument}">
                                                                <i class="fas fa-external-link-alt"></i>
                                                            </a>
                                                        </li>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </ul>
                                    </td>
                                </tr>
                                </xsl:if>
                                <tr>
                                    <th></th>
                                    <td>
                                        Anzahl der Erwähnungen limitiert, klicke <a href="{$selfLink}">hier</a> für eine vollständige Auflistung
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:listPlace">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:place">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="5" />
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="modal fade" id="{@xml:id}" data-bs-keyboard="false" tabindex="-1" aria-labelledby="{if(./tei:settlement) then(./tei:settlement/tei:placeName) else (./tei:placeName)}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel"><xsl:value-of select="if(./tei:settlement) then(./tei:settlement/tei:placeName) else (./tei:placeName)"/></h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <table>
                            <tbody>
                                <xsl:if test="./tei:country">
                                <tr>
                                    <th>
                                        Country
                                    </th>
                                    <td>
                                        <xsl:value-of select="./tei:country"/>
                                    </td>
                                </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type='GND']/text()">
                                    <tr>
                                        <th>
                                            GND
                                        </th>
                                        <td>
                                            <a href="{./tei:idno[@type='GND']}" target="_blank">
                                                <xsl:value-of select="tokenize(./tei:idno[@type='GND'], '/')[last()]"/>
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type='WIKIDATA']/text()">
                                    <tr>
                                        <th>
                                            Wikidata
                                        </th>
                                        <td>
                                            <a href="{./tei:idno[@type='WIKIDATA']}" target="_blank">
                                                <xsl:value-of select="tokenize(./tei:idno[@type='WIKIDATA'], '/')[last()]"/>
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type='GEONAMES']/text()">
                                    <tr>
                                        <th>
                                            Geonames
                                        </th>
                                        <td>
                                            <a href="{./tei:idno[@type='GEONAMES']}" target="_blank">
                                                <xsl:value-of select="tokenize(./tei:idno[@type='GEONAMES'], '/')[4]"/>
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:if>
                                <xsl:if test="./tei:listEvent">
                                <tr>
                                    <th>
                                        Erwähnungen
                                    </th>
                                    <td>
                                        <ul>
                                            <xsl:for-each select=".//tei:event">
                                                <xsl:variable name="linkToDocument">
                                                    <xsl:value-of select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')"/>
                                                </xsl:variable>
                                                <xsl:choose>
                                                    <xsl:when test="position() lt $showNumberOfMentions + 1">
                                                        <li>
                                                            <xsl:value-of select=".//tei:title"/><xsl:text> </xsl:text>
                                                            <a href="{$linkToDocument}">
                                                                <i class="fas fa-external-link-alt"></i>
                                                            </a>
                                                        </li>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </ul>
                                    </td>
                                </tr>
                                </xsl:if>
                                <tr>
                                    <th></th>
                                    <td>
                                        Anzahl der Erwähnungen limitiert, klicke <a href="{$selfLink}">hier</a> für eine vollständige Auflistung
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:listOrg">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:org">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="5" />
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="modal fade" id="{@xml:id}" data-bs-keyboard="false" tabindex="-1" aria-labelledby="{if(./tei:settlement) then(./tei:settlement/tei:placeName) else (./tei:placeName)}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel"><xsl:value-of select="if(./tei:settlement) then(./tei:settlement/tei:placeName) else (./tei:placeName)"/></h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <table class="table">
                            <tbody>
                                <xsl:if test="./tei:idno[@type='GEONAMES']">
                                <tr>
                                    <th>
                                        Geonames ID
                                    </th>
                                    <td>
                                        <a href="{./tei:idno[@type='GEONAMES']}" target="_blank">
                                            <xsl:value-of select="tokenize(./tei:idno[@type='GEONAMES'], '/')[4]"/>
                                        </a>
                                    </td>
                                </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type='WIKIDATA']">
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
                                <xsl:if test="./tei:idno[@type='GND']">
                                <tr>
                                    <th>
                                        GND ID
                                    </th>
                                    <td>
                                        <a href="{./tei:idno[@type='GND']}" target="_blank">
                                            <xsl:value-of select="tokenize(./tei:idno[@type='GND'], '/')[last()]"/>
                                        </a>
                                    </td>
                                </tr>
                                </xsl:if>
                                <xsl:if test="./tei:listEvent">
                                <tr>
                                    <th>
                                        Erwähnungen
                                    </th>
                                    <td>
                                        <ul>
                                            <xsl:for-each select=".//tei:event">
                                                <xsl:variable name="linkToDocument">
                                                    <xsl:value-of select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')"/>
                                                </xsl:variable>
                                                <xsl:choose>
                                                    <xsl:when test="position() lt $showNumberOfMentions + 1">
                                                        <li>
                                                            <xsl:value-of select=".//tei:title"/><xsl:text> </xsl:text>
                                                            <a href="{$linkToDocument}">
                                                                <i class="fas fa-external-link-alt"></i>
                                                            </a>
                                                        </li>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </ul>
                                    </td>
                                </tr>
                                </xsl:if>
                                <tr>
                                    <th></th>
                                    <td>
                                        Anzahl der Erwähnungen limitiert, klicke <a href="{$selfLink}">hier</a> für eine vollständige Auflistung
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:listBibl">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:bibl">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="5" />
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="modal fade" id="{@xml:id}" data-bs-keyboard="false" tabindex="-1" aria-labelledby="{./tei:title[@type='main']}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel"><xsl:value-of select="./tei:title"/></h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <table class="table">
                            <tbody>

                                <tr>
                                    <th>
                                        Autor(en)
                                    </th>
                                    <td>
                                        <ul>
                                            <xsl:for-each select="./tei:author">
                                                <li>
                                                    <a href="{@xml:id}.html">
                                                        <xsl:value-of select="./tei:persName"/>
                                                    </a>
                                                </li>
                                            </xsl:for-each>
                                        </ul>
                                    </td>
                                </tr>
                                <xsl:if test="./tei:idno[@type='GEONAMES']">
                                <tr>
                                    <th>
                                        Geonames ID
                                    </th>
                                    <td>
                                        <a href="{./tei:idno[@type='GEONAMES']}" target="_blank">
                                            <xsl:value-of select="tokenize(./tei:idno[@type='GEONAMES'], '/')[4]"/>
                                        </a>
                                    </td>
                                </tr>
                                </xsl:if>
                                <xsl:if test="./tei:idno[@type='WIKIDATA']">
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
                                <xsl:if test="./tei:idno[@type='GND']">
                                <tr>
                                    <th>
                                        GND ID
                                    </th>
                                    <td>
                                        <a href="{./tei:idno[@type='GND']}" target="_blank">
                                            <xsl:value-of select="tokenize(./tei:idno[@type='GND'], '/')[last()]"/>
                                        </a>
                                    </td>
                                </tr>
                                </xsl:if>
                                <xsl:if test="./tei:listEvent">
                                <tr>
                                    <th>
                                        Erwähnungen
                                    </th>
                                    <td>
                                        <ul>
                                            <xsl:for-each select=".//tei:event">
                                                <xsl:variable name="linkToDocument">
                                                    <xsl:value-of select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')"/>
                                                </xsl:variable>
                                                <xsl:choose>
                                                    <xsl:when test="position() lt $showNumberOfMentions + 1">
                                                        <li>
                                                            <xsl:value-of select=".//tei:title"/><xsl:text> </xsl:text>
                                                            <a href="{$linkToDocument}">
                                                                <i class="fas fa-external-link-alt"></i>
                                                            </a>
                                                        </li>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </ul>
                                    </td>
                                </tr>
                                </xsl:if>
                                <tr>
                                    <th></th>
                                    <td>
                                        Anzahl der Erwähnungen limitiert, klicke <a href="{$selfLink}">hier</a> für eine vollständige Auflistung
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <!-- <xsl:template match="tei:rs[@ref or @key]">
        <strong>
            <xsl:element name="a">
                <xsl:attribute name="data-toggle">modal</xsl:attribute>
                <xsl:attribute name="data-target">
                    <xsl:value-of select="data(@ref)"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
        </strong>
    </xsl:template> -->

</xsl:stylesheet>
