<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns="http://www.w3.org/2005/xpath-functions"
    version="3.0" exclude-result-prefixes="#all">

	<xsl:output encoding="UTF-8" method="text" indent="yes" omit-xml-declaration="yes"/>

	<xsl:template match="/">
		<xsl:variable name="files" select="collection('../../data/editions/legacy')"/>
		<xsl:variable name="files2" select="collection('../../data/editions/present')"/>
		<xsl:variable name="xml">
			<map>
				<xsl:for-each select="$files//tei:TEI">
					<map key="{@xml:id}">
						<string key="title">
							<xsl:value-of select="//tei:titleStmt/tei:title[@level='a' or @type='num']"/>
						</string>
						<string key="corpus">
							<xsl:choose>
								<xsl:when test="contains(@xml:id, 'wr_')">
									<xsl:text>2</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>1</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</string>
					</map>
				</xsl:for-each>
				<xsl:for-each select="$files2//tei:TEI">
					<map key="{substring-before(@xml:id, '.xml')}">
						<string key="title">
								<xsl:value-of select="//tei:titleStmt/tei:title[@level='a' or @type='num']"/>
						</string>
						<string key="corpus">
							<xsl:choose>
								<xsl:when test="contains(@xml:id, 'wr_')">
									<xsl:text>2</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>1</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</string>
					</map>
				</xsl:for-each>
			</map>
		</xsl:variable>
		<!-- OUTPUT -->
		<xsl:value-of select="xml-to-json($xml)"/>
	</xsl:template>

</xsl:stylesheet>
