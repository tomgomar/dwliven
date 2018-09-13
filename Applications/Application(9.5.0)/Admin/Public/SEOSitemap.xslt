<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" omit-xml-declaration="no" indent="yes"  encoding="utf-8" />

  <xsl:template match="/NavigationTree">
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
      <xsl:apply-templates select="//Page">
      </xsl:apply-templates>
    </urlset>
  </xsl:template>

  <xsl:template match="//Page[@FriendlyHref!='' and @FriendlyHref!='/']">
	<xsl:if test="@ShowInSitemap='True'">
    <xsl:element name="url" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" >
      <loc>
        <xsl:value-of select="@FriendlyHref"/>
      </loc>
    </xsl:element>
	</xsl:if>
  </xsl:template>

</xsl:stylesheet>