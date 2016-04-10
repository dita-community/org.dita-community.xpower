<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:test="something"
    
    xmlns:java-file="java:java.io.File"
    xmlns:java-uri="java:java.net.URI">
    
    <xsl:template match="/">
        <xsl:value-of select="test:file-exists('file:///f:/hs/ActivationXE5.png')"/>
        <!-- 534x591 -->
            
    </xsl:template>
    
    <xsl:function name="test:file-exists" as="xs:boolean">
        <xsl:param name="fileURL" as="xs:string"/>
        <xsl:sequence select="java-file:exists(java-file:new(java-uri:new($fileURL)))"/>
    </xsl:function>
    
    <xsl:function name="test:image-width" as="xs:string">
        <xsl:param name="fileURL" as="xs:string"/>
        <xsl:sequence select="java-file:new(java-uri:new($fileURL))"/>
    </xsl:function>
    
</xsl:stylesheet>

<!--
    
import javax.swing.ImageIcon;
 
public class ImageInfo
{
  public static int getHeight(String filename)
  {
    ImageIcon image = new ImageIcon(filename);
    return image.getIconHeight();
  }
 
  public static int getWidth(String filename) 
  {
    ImageIcon image = new ImageIcon(filename);
    return image.getIconWidth();
  }
}
  
-->
