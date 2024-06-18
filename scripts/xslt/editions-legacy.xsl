<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="#all">

<xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" indent="yes" omit-xml-declaration="yes"/>

<xsl:import href="./partials/shared.xsl"/>
<xsl:import href="./partials/aot-options.xsl"/>

<xsl:variable name="prev">
		<xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '')"/>
</xsl:variable>
<xsl:variable name="next">
		<xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '')"/>
</xsl:variable>
<xsl:variable name="teiSource">
		<xsl:value-of select="data(tei:TEI/@xml:id)"/>
</xsl:variable>
<xsl:variable name="link">
		<xsl:value-of select="replace($teiSource, '.xml', '')"/>
</xsl:variable>
<xsl:variable name="doc_title">
		<xsl:value-of select=".//tei:titleStmt/tei:title[@type='num']/text()|.//tei:titleStmt/tei:title[@level='a']/text()"/>
</xsl:variable>

<xsl:template match="/">
<div class="flex flex-row transcript active p-4 sm:p-2">
	<div class="basis-7/12 text px-4 yes-index sm:px-2 sm:basis-full md:basis-full">
		<div class="section">
			<div class="flex flex-col items-center">
				<xsl:for-each select=".//tei:front/tei:titlePage|.//tei:body">
						<xsl:apply-templates/>
				</xsl:for-each>
			</div>
		</div>
	</div>
	<div class="basis-5/12 facsimiles sm:hidden md:hidden">
		<div id="viewer-1" class="sticky top-4">
			<div id="container_facs_1">
			</div>
		</div>
	</div>
</div>
<xsl:for-each select="//tei:back">
<div class="tei-back">
    <xsl:apply-templates/>
</div>
</xsl:for-each>

</xsl:template>

<xsl:template match="//text()[parent::tei:p[ancestor::tei:body]]|
										//text()[parent::tei:ab[ancestor::tei:body]]|
										//text()[parent::tei:head[ancestor::tei:body]]">
	<xsl:choose>
		<xsl:when test="following-sibling::tei:*[1]/@break='no'">
			<xsl:value-of select="replace(., '\s+$', '')"/>
		</xsl:when>
		<xsl:when test="matches(., '=$', 'm')">
			<xsl:value-of select="replace(., '\s+$', '')"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="."/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:docTitle">
	<div class="title-page p-4" id="#top_page">
		<xsl:apply-templates/>
	</div>
</xsl:template>

<xsl:template match="tei:titlePart">
	<xsl:choose>
		<xsl:when test="@type='num'">
			<h5 id="{@xml:id}" class="yes-index {if(contains(@rendition, 'f')) then('text-center') else('text-right')} py-4 text-lg"><xsl:apply-templates/></h5>
		</xsl:when>
		<xsl:when test="@type='main'">
			<h4	id="{@xml:id}" class="yes-index {if(contains(@rendition, 'f')) then('text-center') else('text-right')} py-4 text-lg"><xsl:apply-templates/></h4>
		</xsl:when>
		<xsl:otherwise>
			<h5 id="{@xml:id}" class="yes-index {if(contains(@rendition, 'f')) then('text-justify') else('text-right')} py-4 text-lg"><xsl:apply-templates/></h5>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:milestone">
	<hr class="mx-10 p-4 border-gray-500"/>
</xsl:template>

<xsl:template match="tei:imprimatur">
	<div id="{@xml:id}">
		<p class="yes-index italic text-center py-4"><xsl:apply-templates/></p>
	</div>
</xsl:template>

<xsl:template match="tei:lb">
	<br class="linebreak"/>
</xsl:template>

<xsl:template match="tei:w">
	<xsl:apply-templates/>
	<xsl:if test="following-sibling::*[1][@break]">
		<span class="linebreak"><xsl:text>=</xsl:text></span>
	</xsl:if>
	<xsl:if test="self::tei:w[not(following-sibling::tei:w)]/parent::tei:item/following-sibling::*[1][@break]">
		<xsl:text>=</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="tei:pc">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="tei:fw[@type='catch' or not(@type)]">
	<div id="{@xml:id}" class="basis-full float-right text-right px-4">
		<span class="yes-index">
			<xsl:apply-templates/>
		</span>
	</div>
</xsl:template>
<xsl:template match="tei:fw[@type='sig']">
	<div id="{@xml:id}" class="basis-full text-center">
		<span class="yes-index catch-word">
			<xsl:apply-templates/>
		</span>
	</div>
</xsl:template>
<xsl:template match="tei:fw[@type='pageNum']">
	<div id="{@xml:id}" class="basis-full text-center">
		<span class="yes-index catch-word">
			<xsl:apply-templates/>
		</span>
	</div>
</xsl:template>

<xsl:template match="tei:div[@type='page']">
	<div class="py-2 px-4 basis-full">
		<xsl:apply-templates select=".//tei:pb"/>
			<xsl:if test="./tei:div[./*[contains(@rendition, 'f')]]">
				<div class="flex flex-row">
					<div class="basis-full">
						<xsl:apply-templates select="./tei:div/*[contains(@rendition, 'f')]"/>
					</div>
				</div>
			</xsl:if>
			<xsl:if test="./tei:div[./*[contains(@rendition, 'r')]] or ./tei:div[./*[contains(@rendition, 'l')]]">
				<div class="flex flex-row">
					<div class="basis-6/12 sm:basis-full">
						<xsl:apply-templates select="./tei:div/*[contains(@rendition, 'l')]"/>
					</div>
					<div class="basis-6/12 sm:basis-full">
						<xsl:apply-templates select="./tei:div/*[contains(@rendition, 'r')]"/>
					</div>
				</div>
			</xsl:if>
		<xsl:apply-templates select=".//tei:fw"/>
	</div>
</xsl:template>

<xsl:template match="tei:head">
	<h5 id="{@xml:id}" class="yes-index text-center font-semibold px-4 pt-2">
		<xsl:apply-templates/>
	</h5>
</xsl:template>

<xsl:template match="tei:p">
	<p id="{@xml:id}" class="yes-index text-justify px-4 py-2">
		<xsl:apply-templates/>
		<!--<xsl:if test="following-sibling::tei:p[@prev]">
				<xsl:if test="following-sibling::*[1]/name() = 'pb'">
						<xsl:for-each select="following-sibling::*[1]">
								<span class="anchor-pb"></span>
								<span class="pb lightgrey" source="{@facs}">[<xsl:value-of select="./@n"/>]</span>
						</xsl:for-each>
				</xsl:if>
				<xsl:for-each select="following-sibling::tei:p[@prev]">
						<xsl:apply-templates/>
				</xsl:for-each>
		</xsl:if>-->
	</p>
</xsl:template>

<xsl:template match="tei:list">
	<ul id="{@xml:id}" class="px-4 py-2">
		<xsl:apply-templates/>
	</ul>
</xsl:template>

<xsl:template match="tei:item">
	<li class="yes-index {if(preceding-sibling::*[1]/@break = 'no') then 'ml-4' else ''}"
			data-zone="{@facs}"
			data-num="{@n}">
		<xsl:apply-templates/>
	</li>
</xsl:template>

<!--<xsl:template match="tei:p[@prev]"/>-->

<!--<xsl:template match="tei:pb[following-sibling::tei:p[@prev]]"/>-->

<!--    <xsl:template match="tei:div">
		<!-\-<div id="{local:makeId(.)}">
				<xsl:apply-templates/>
		</div>-\->
		<xsl:apply-templates/>
</xsl:template>  -->

</xsl:stylesheet>
