<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
                xmlns:data="urn:schemas-microsoft-com:xml-data">
  <xsl:output method="html" version="1.0" encoding="US-ASCII" indent="yes" />
  <!--Global variable to compare empty nodes-->
  <xsl:variable name="empty_string"/>

  <!--***********************Footer*****************************************************-->
  <xsl:template name="footer">
    <xsl:param name="collectionID"/>

    <xsl:if test="normalize-space($collectionID) != $empty_string">
      <xsl:choose>

        <!--Deloitte Publications- Presentations<DONE>-->
        <xsl:when test="$collectionID='WhatsNewOnTechnicalLibrary' or 
                  $collectionID='2_9597222' or
                  $collectionID='2_5416935' or
                  $collectionID='2_17939838'">
          <table cellpadding="0" cellspacing="0" border="0" width="100%" leftmargin="0" topmargin="0" marginheight="0" marginwidth="0">
            <tr>
              <td no="" wrap="" colspan="2">
                <hr/>
              </td>
            </tr>
            <tr>
              <td align="left" colspan="3" valign="top" width="100%"> </td>
            </tr>
            <tr>
              <td width="65%">
                <font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                  Copyright © 2011 Deloitte Development LLC.<br/>
                </font>
              </td>
              <td width="45%">
                <font face="Verdana, Arial, Helvetica, sans-serif" size="1">Member of</font>
              </td>
            </tr>
            <tr>
              <td width="65%">
                <font face="Verdana, Arial, Helvetica, sans-serif" size="1">All Rights Reserved.</font>
              </td>
              <td width="45%">
                <font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                  <b>Deloitte Touche Tohmatsu Limited</b>
                </font>
              </td>
            </tr>
          </table>
        </xsl:when>

        <!--Deloitte U.S. Accounting & Reporting Guidance<DONE>-->
        <xsl:when test="$collectionID='2_1568921' or 
                  $collectionID='2_5459355' or
                  $collectionID='2_18177602'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b>Confidential and Proprietary — for Use Solely by Authorized Personnel</b>
            <BR/>
          </P>
          <P ALIGN="left" CLASS="dtCopyrightnobegin">
            This publication provides comprehensive guidance; however, it does not address all possible fact patterns, and the guidance is subject to change.
            Consult a Deloitte &amp; Touche LLP professional regarding your specific issues and questions.<BR/>
            Your feedback will help us improve the <I>FASB Accounting Standards Codification Manual.</I> Please <a href="mailto:accountingstandards@deloitte.com?subject=Accounting%20Standards%20Codification%20Manual%20Feedback">let us know</a> what you think.<BR/>
            Copyright © 2011 Deloitte Development LLC. All rights reserved.<BR/>
            FASB Accounting Standards Codification: Copyright © 2005–2011 by Financial Accounting Foundation, Norwalk, Connecticut<BR/>
          </P>
        </xsl:when>

	<!--Find the GAAP<DONE>-->
        <xsl:when test="$collectionID='2_8937880'">
          <P ALIGN="left" CLASS="dtCopyrightnobegin">
            Copyright © 2005–2011 by Financial Accounting Foundation, Norwalk, Connecticut<BR/>
          </P>
</xsl:when>

        <!--U.S. Practice Aids <DONE> -->
        <xsl:when test="$collectionID='2_37156504'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b>Confidential and Proprietary – for Use Solely by Authorized Personnel</b>
            <BR/>
            U.S. Guides, Practice Aids, and FAQs for Auditors<BR/>
            Copyright © 2011 Deloitte &amp; Touche LLP. All rights reserved.
          </P>
</xsl:when>

        <!--U.S. Practice Alerts <DONE> -->
        <xsl:when test="$collectionID='2_36872275'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b>Confidential and Proprietary – for Use Solely by Authorized Personnel</b>
            <BR/>
            U.S. Practice Alerts<BR/>
            Copyright © 2011 Deloitte &amp; Touche LLP. All rights reserved.
          </P>
        </xsl:when>

	<!--U.S. Audit Quality Alerts<DONE>-->
        <xsl:when test="$collectionID='2_28874559'">
	  <P ALIGN="center" CLASS="dtCopyright">
            <B>Confidential and Proprietary — for Use Solely by Authorized Personnel</B>
            <BR/>U.S. Audit Quality Alerts<BR/>
	    Copyright © 2011 Deloitte &amp; Touche LLP. All rights reserved.
          </P>
        </xsl:when>

        <!--SEC Reporting Interpretations Manual<DONE>-->
        <xsl:when test="$collectionID='2_8776659'">
          <P ALIGN="center" CLASS="dtCopyright">
            <B>Confidential and Proprietary — for Use Solely by Authorized Personnel</B>
            <BR/>
          </P>
          <P ALIGN="left" CLASS="dtCopyrightnobegin">
            This SEC Reporting Interpretations manual provides comprehensive guidance; however, the manual
            does not address all possible fact patterns, and the guidance is subject to change.
            Consult a Deloitte &amp; Touche LLP professional regarding your specific issues and questions.<BR/>
            Copyright © 2011 Deloitte Development LLC. All rights reserved.<BR/>
          </P>
          <P ALIGN="left" CLASS="dtCopyrightnobegin">Regulation S-X: Source CCH Incorporated. All rights reserved.</P>
        </xsl:when>

        <!--US AAPMS Manuals-Landing Page<DONE>
            AAPMS General Policies Manual<DONE>
            AUDIT APPROACH MANUAL<DONE>
            AAPMS ACCOUNTANTS' REPORTS MANUAL<DONE>
            AAPMS SEC MANUAL<DONE>
            AAPMS OTHER SPECIALIZED SERVICES<DONE>
            AAPMS INDUSTRY MANUAL<DONE>
            AAPMS ENTERPRISE RISK SERVICES PROFESSIONAL PRACTICE MANUAL<DONE>
            AAPMS VALUATION PRACTICE MANUAL<DONE>
            AAPMS REPORTING ADVISORY SERVICES POLICIES MANUAL<DONE>-->
        <xsl:when test="$collectionID='2_7932293'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b>Confidential and Proprietary - for Use Solely by Authorized Personnel</b>
            <BR/>
            U.S. AAPMS AAM, GEN, REP, SEC, OSS, IND, and ERS<BR/>
            Copyright © 2011 Deloitte &amp; Touche LLP. All rights reserved.
	    <BR/>
            U.S. AAPMS VAL<BR/>
            Copyright © 2011 Deloitte Financial Advisory Services LLP. All rights reserved.
          </P>
        </xsl:when>

        <!--U.S. AAM - 2010 <DONE> -->
        <xsl:when test="$collectionID='2_24148685'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b>Confidential and Proprietary – for Use Solely by Authorized Personnel</b>
            <BR/>
            U.S. AAM<BR/>
            Copyright © 2011 Deloitte &amp; Touche LLP. All rights reserved.
          </P>
        </xsl:when>

        <!--U.S. DELOITTE POLICIES MANUAL<DONE> -->
        <xsl:when test="$collectionID='2_4452820'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b>Confidential and Proprietary - for Use Solely by Authorized Personnel</b>
            <BR/>
            U.S. Deloitte Policies Manual<BR/>
            Copyright © 2011 Deloitte &amp; Touche LLP. All rights reserved.
          </P>
        </xsl:when>

        <!--INFORM<DONE> -->
        <xsl:when test="$collectionID='2_4454749'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b>Confidential and Proprietary - for Use Solely by Authorized Personnel</b>
            <BR/>INFORM<BR/>
            Copyright © 2011 Deloitte &amp; Touche LLP. All rights reserved.
          </P>
        </xsl:when>

      <!--NFOItems 2008> -->
        <xsl:when test="$collectionID='2_4457163'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b>Confidential and Proprietary - for Use Solely by Authorized Personnel</b>
            <BR/>2008 NFOItems<BR/>
            Copyright © 2011 Deloitte &amp; Touche LLP. All rights reserved.<BR/>
          </P>
        </xsl:when>

      <!--NFOItems 2009> -->
        <xsl:when test="$collectionID='2_4456478'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b>Confidential and Proprietary - for Use Solely by Authorized Personnel</b>
            <BR/>2009 NFOItems<BR/>
            Copyright © 2011 Deloitte &amp; Touche LLP. All rights reserved.<BR/>
          </P>
        </xsl:when>

        <!--NFOItems 2010> -->
        <xsl:when test="$collectionID='2_20390440'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b>Confidential and Proprietary - for Use Solely by Authorized Personnel</b>
            <BR/>2010 NFOItems<BR/>
            Copyright © 2011 Deloitte &amp; Touche LLP. All rights reserved.<BR/>
          </P>
        </xsl:when>
        <!--NFOItems 2011> -->
        <xsl:when test="$collectionID='2_51038771'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b>Confidential and Proprietary - for Use Solely by Authorized Personnel</b>
            <BR/>2011 NFOItems<BR/>
            Copyright © 2011 Deloitte &amp; Touche LLP. All rights reserved.<BR/>
          </P>
        </xsl:when>

        <!--IFAC 2008 Handbook<DONE> -->
        <xsl:when test="$collectionID='3_4452579' or
                  $collectionID='3_1937605' or
                        $collectionID='3_1937606' or 
                        $collectionID='3_1820753'">
          <P ALIGN="center" CLASS="dtCopyright">
            2008 IFAC Handbook (currently effective pronouncements on auditing, assurance, and ethics issued by IFAC as of January 1, 2008)
            <BR/>Copyright © 2008 Deloitte Touche Tohmatsu and International Federation of Accountants.
            All rights reserved.
          </P>
        </xsl:when>

        <!--International Accounting Manual, Newsletters and Publications (Deloitte Touche Tohmatsu) - LANDING PAGE<DONE>;
            IASB Literature - Landing Page-->
        <xsl:when test="$collectionID='3_1820759' or
                        $collectionID='IASB Literature - Landing Page'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b>Confidential and Proprietary - for Use Solely by Authorized Personnel</b>
            <BR/>
            Copyright © 2010 Deloitte Touche Tohmatsu. All rights reserved.<BR/>
          </P>
        </xsl:when>

        <!--International Accounting Manual, Newsletters and Publications (Deloitte Touche Tohmatsu)<DONE> -->
        <xsl:when test="$collectionID='3_1679392' or
                              $collectionID='3_4651506'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b> Confidential and Proprietary - for Use Solely by Authorised Personnel</b>
          </P>
          <P ALIGN="left" CLASS="dtCopyrightnobegin">
            This accounting manual provides comprehensive guidance; however, the manual does not address all possible fact patterns and
            the guidance is subject to change. Consult a  Deloitte Touche Tohmatsu professional regarding
            your specific issues and questions.<BR/> Copyright © 2011 Deloitte Touche Tohmatsu. All rights reserved. <BR/>
          </P>
        </xsl:when>

        <!--SEC Literature -Selected SEC Rules, Regulations, and Forms-->
        <xsl:when test="$collectionID='2_6429590'">
          <p ALIGN="center" CLASS="dtCopyright">
            Selected SEC Rules, Regulations, and Forms.<BR/>
            Copyright © 2011 CCH Incorporated. All rights reserved.
          </p>
        </xsl:when>

        <!--SEC Literature -SEC Material Supplement-->
        <xsl:when test="$collectionID='2_5403691'">
          <P ALIGN="center" CLASS="dtCopyright">
          <BR/>SEC Material - Supplement<BR/>
          Copyright © 2011 Deloitte Development LLC. All rights reserved.
          </P>
        </xsl:when>

        <!--AICPA Literature -AICPA Professional Standards<DONE>-->
        <xsl:when test="$collectionID='2_9010800'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b>Confidential and Proprietary - for Use Solely by Authorized Personnel</b>
            <BR/>AICPA Professional Standards<BR/>
            Copyright © 2009 American Institute of Certified Public Accountants, Inc.
          </P>
        </xsl:when>

        <!--AICPA Literature -AICPA Technical Practice Aids<DONE>-->
        <xsl:when test="$collectionID='2_9010808'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b> Confidential and Proprietary - for Use Solely by Authorized Personnel</b>
            <BR/>AICPA Technical Practice Aids<BR/>
            Copyright © 2009 American Institute of Certified Public Accountants, Inc.
          </P>
        </xsl:when>

        <!--AICPA Literature -AICPA Audit & Accounting Guides & Audit Risk Alerts<DONE>-->
        <xsl:when test="$collectionID='2_9010540'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b> Confidential and Proprietary - for Use Solely by Authorized Personnel</b>
            <BR/>AICPA Accounting &amp; Audit Guides &amp; Audit Risk Alerts<BR/>
            Copyright © 2009 American Institute of Certified Public Accountants, Inc.
          </P>
        </xsl:when>

        <!--AICPA Literature -AICPA Accounting Trends & Techniques<DONE>-->
        <xsl:when test="$collectionID='2_9010778'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b> Confidential and Proprietary - for Use Solely by Authorized Personnel</b>
            <BR/>AICPA Accounting Trends &amp; Techniques<BR/>
            Copyright © 2009 American Institute of Certified Public Accountants, Inc.
          </P>
        </xsl:when>

        <!--AICPA Literature -AICPA Issues Papers-->
        <xsl:when test="$collectionID='2_8780118'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b> Confidential and Proprietary - for Use Solely by Authorized Personnel</b>
            <BR/>AICPA Issues Papers<BR/>
            Copyright © 2011 American Institute of Certified Public Accountants, Inc.
          </P>
        </xsl:when>

        <!--AICPA - PCAOB Standards and Related Rules-->
        <xsl:when test="$collectionID='2_9010782'">          
        <P ALIGN="center" CLASS="dtCopyright">
            <b> Confidential and Proprietary - for Use Solely by Authorized Personnel</b>
            <BR/> Auditing Standards © 2004–2010 by the Public Company Accounting Oversight Board (PCAOB).<BR/>
          Interim Standards © 2004–2010 by the American Institute of Certified Public Accountants, Inc.<BR/>
          PCAOB Staff Guidance © 2004–2010 by the Public Company Accounting Oversight Board (PCAOB).<BR/>
          Select Rules of the Board © 2004–2010 by the Public Company Accounting Oversight Board (PCAOB).<BR/>
          Select PCAOB Releases © 2004–2010 by the Public Company Accounting Oversight Board (PCAOB).<BR/>
        </P>
        </xsl:when>


        <!--GASB Literature - GASB Topical Index
            GASB Literature - GASB Effective Dates of Pronouncements
            GASB Literature - Finding List of Original Pronouncements-->
        <xsl:when test="$collectionID='2_6454697' or
                  $collectionID='2_6454908' or
                        $collectionID='2_6454910'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b>Confidential and Proprietary - for Use Solely by Authorized Personnel</b>
            <BR/>GASB Literature <BR/>
            Copyright © 2009 Governmental Accounting Standards Board.
          </P>
        </xsl:when>

        <!--IFRS Literature -->
        <xsl:when test="$collectionID='3_1787803' or
                        $collectionID='3_1820758'">
          <P ALIGN="center" CLASS="dtCopyright">
            <b>Confidential and Proprietary - for Use Solely by Authorized Personnel</b>
            <BR/>International Financial Reporting Standards (IFRSs), International Accounting Standards (IASs)
            and Interpretations<BR/>
            Copyright © 2009 Deloitte Touche Tohmatsu and IASCF. All rights reserved.
          </P>
        </xsl:when>

        <!--Deloitte Audit Approach Manual (2009)-->
        <xsl:when test="$collectionID='3_4446819'">
          <P ALIGN="center" CLASS="dtCopyright">
            <BR/>Deloitte Audit Approach Manual first published December 2007.<BR/>
            Copyright © 2009 Deloitte Touche Tohmatsu. All rights reserved.
          </P>
        </xsl:when>
        
        <!--Deloitte Audit Approach Manual (2010)-->
        <xsl:when test="$collectionID='3_19553756'">
          <P ALIGN="center" CLASS="dtCopyright">
            <BR/>Deloitte Touche Tohmatsu Limited Audit Approach Manual published October 2009; modified July 2010, September 2010.<BR/>
            Copyright 2010 Deloitte Touche Tohmatsu Limited. All rights reserved
          </P>
        </xsl:when>
        
        <!--IFAC 2010-->
        <xsl:when test="$collectionID='3_8964487'">
          <P ALIGN="center" CLASS="dtCopyright">
            <BR/>2010 IFAC Handbook<BR/>
            Copyright © April 2010 by the International Federation of Accountants (IFAC). All rights reserved.
          </P>
        </xsl:when>

        <!--Checklist Jaarverslaggeving 2009-->
        <xsl:when test="$collectionID='4_19552550'">
          <P ALIGN="center" CLASS="dtCopyright">
            <BR/><b>I = Inrichtingsplicht, P = Publicatieplicht, W = Wettelijke vereiste, S = Stellige uitspraak in RJ, A = aanbeveling in RJ, s(o) = stellige uitspraak in oRJ, a(o) = aanbevolen in oRJ, - = niet vereist</b><BR/>
            <BR/>
            De samenstellers zijn zich volledig bewust van hun taak een zo betrouwbaar mogelijke checklist te verzorgen. Niettemin kunnen zij geen aansprakelijkheid aanvaarden voor eventueel in deze checklist voorkomende onvolledigheden en/of onjuistheden.<BR/>
            © Deloitte, december 2010
          </P>
        </xsl:when>

        <!--All NL Handboeks<DONE>-->
        <xsl:when test="$collectionID='4_21685314' or
                  $collectionID='4_21685388' or
                  $collectionID='4_21685476' or
                  $collectionID='4_21685447' or
                  $collectionID='4_21685415'">
          <P ALIGN="left" CLASS="dtCopyright">
            <BR/> De auteurs zijn zich volledig bewust van hun taak een zo betrouwbaar mogelijke uitgave te verzorgen. Niettemin kunnen zij geen aansprakelijkheid voeren voor onvolledigheden en/of onjuistheden die <BR/>
            eventueel in deze uitgave voorkomen. Alle rechten zijn voorbehouden. Niets uit deze uitgave mag worden verveelvoudigd of openbaar gemaakt zonder voorafgaande toestemming van de uitgever.
            <BR/>
            © Deloitte, december 2009
          </P>

        </xsl:when>
        <!--DTT Policies Manual -ERS-->
        <xsl:when test="$collectionID='3_21180497'">
          <P ALIGN="center" CLASS="dtCopyright">
            <BR/>Deloitte Policies Manual – Enterprise Risk Services updated as of October 2010.<BR/>
            Copyright © 2010 Deloitte Touche Tohmatsu Limited. All rights reserved.
          </P>
        </xsl:when>

        <!--NL Policies Manual -Audit-->
        <xsl:when test="$collectionID='4_37182397'">
          <P ALIGN="center" CLASS="dtCopyright">
            <BR/>NL Deloitte Policies Manual – Audit amended July 2010.<BR/>
            Copyright © 2010 Deloitte Touche Tohmatsu Limited. All rights reserved.
          </P>
        </xsl:when>

        <!--NL Audit Approach Manual (2010)-->
        <xsl:when test="$collectionID='4_24311657'">
          <P ALIGN="center" CLASS="dtCopyright">
            <BR/>NL Deloitte Audit Approach Manual first published October 2009; amended July 2010, September 2010.<BR/>
            Copyright © 2010 Deloitte Touche Tohmatsu Limited. All rights reserved.
          </P>
        </xsl:when>

        <!--ANNA MKB Accountancy Approach-->
        <xsl:when test="$collectionID='4_17499053'">
          <P ALIGN="center" CLASS="dtCopyright">
            <BR/>MKB Accountancy Approach. December 2010.<BR/>
            Copyright © 2010 Deloitte Accountants B.V. All rights reserved.
          </P>
        </xsl:when>
          
        <!--DTT Policies Manual -Audit-->
        <xsl:when test="$collectionID='3_4446420' or
                        $collectionID='3_1794540'">
          <P ALIGN="center" CLASS="dtCopyright">
            <BR/>DTTL Policies Manual – Audit amended October 2010.<BR/>
            Copyright © 2010 Deloitte Touche Tohmatsu Limited. All rights reserved.
          </P>
        </xsl:when>
             
      </xsl:choose>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
