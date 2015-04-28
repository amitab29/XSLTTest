<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">

  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
  <xsl:variable name="empty_string"/>

  <xsl:template match="/">
    <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
  </xsl:template>

  <xsl:template match="*">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>
        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="name()='shortdesc' or name()='paras' or name()='para' or name()='qa-prolog'
						  or name()='policy' or name()='guidance' or name()='qa' or name()='question' 
						  or name()='answer' or name()='exhibit' or name()='critdates' or  name()='created' 
						  or name()='revised' or name()='subsection' or name()='subsectbody' or name()='p-norm'
							or name()='topic' or name()='background' or name()='section' or name()='transformedContent'
							or name()='outputclass_indent' or name()='related-links' or name()='link'
							or name()='related_links_linklist' or name()='colspec' or name()='guidance-example'">
          <xsl:call-template name="AddBlockDisplayStyle"/>
        </xsl:when>
        <xsl:when test="name()='term' or name()='qa-id' or name()='guidance-text' or name()='guidance-phrase' 
						  or name()='qa-source' or name()='qa-title_after' or name()='qa-id_after' or name()='norm-text'
							or name()='glossref' or name()='dl' or name()='dd' or name()='dlentry' or name()='xref-DTL'
							or name()='linktext' or name()='secondary-link' or name()='sfragdata' or name()='att' ">
          <xsl:call-template name="AddInlineDisplayStyle"/>
        </xsl:when>
        <xsl:when test="name()='policy-prolog' or name()='guidance-prolog' or name()='dtl-topic-prolog'
						  or name()='subsect-prolog'or name()='related-links-bottom'">
          <xsl:call-template name="AddNoDisplayStyle"/>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="content-domain">
    <xsl:element name="{name()}">
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>
        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>
      <xsl:copy-of select="normalize-space()"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="AddOtherClasses">
    <!--Do not add the existing classes of type " - topic/body asc/subsectbody ". These cause the required styles to be ignored.-->
    <xsl:if test="@class and not(contains(@class,'/') or contains(@class,'\'))">
      <xsl:value-of select="concat(' ',@class)"/>
    </xsl:if>

    <xsl:call-template name="CheckAttributes"/>
  </xsl:template>

  <xsl:template name="CheckAttributes">
    <xsl:if test="@otherprops='non-authoritative'">
      <xsl:value-of select="' otherprops_non-authoritative'"/>
    </xsl:if>

    <xsl:if test="name()=xref or name()=xref-3rdParty or name()=xref-DTL">
      <xsl:choose>
        <xsl:when test="@outputclass='resolved'">
          <xsl:value-of select="' resolved'"/>
        </xsl:when>
        <xsl:when test="@outputclass='unresolved'">
          <xsl:value-of select="' unresolved'"/>
        </xsl:when>
        <xsl:when test="@outputclass='multiple'">
          <xsl:value-of select="' multiple'"/>
        </xsl:when>
      </xsl:choose>
    </xsl:if>

    <xsl:if test="name()=linkref and (name(..)=primary-link or name(..)=secondary-link)">
      <xsl:choose>
        <xsl:when test="../@outputclass='resolved'">
          <xsl:value-of select="' resolved_linkref'"/>
        </xsl:when>
        <xsl:when test="../@outputclass='unresolved'">
          <xsl:value-of select="' unresolved_linkref'"/>
        </xsl:when>
        <xsl:when test="../@outputclass='multiple'">
          <xsl:value-of select="' multiple_linkref'"/>
        </xsl:when>
      </xsl:choose>
    </xsl:if>

    <xsl:if test="@outputclass='policy'">
      <xsl:value-of select="' outputclass_policy'"/>
    </xsl:if>

    <xsl:if test="@outputclass='superseded'">
      <xsl:value-of select="' outputclass_superseded'"/>
    </xsl:if>

    <xsl:if test="@outputclass='plain'">
      <xsl:value-of select="' outputclass_plain'"/>
    </xsl:if>

    <xsl:if test="@outputclass='indent'">
      <xsl:value-of select="' outputclass_indent'"/>
    </xsl:if>

    <xsl:if test="@outputclass='nospace'">
      <xsl:value-of select="' outputclass_nospace'"/>
    </xsl:if>

    <xsl:if test="@outputclass='letter-report'">
      <xsl:value-of select="' outputclass_letter-report'"/>
    </xsl:if>

    <xsl:if test="@importance='high'">
      <xsl:value-of select="' importance_high'"/>
    </xsl:if>

    <xsl:if test="@status='new'">
      <xsl:value-of select="' status_new'"/>
    </xsl:if>

    <xsl:if test="@status='deleted'">
      <xsl:value-of select="' status_deleted'"/>
    </xsl:if>

    <xsl:if test="@status='changed'">
      <xsl:value-of select="' status_changed'"/>
    </xsl:if>

    <xsl:if test="@class='topic/simpletable'">
      <xsl:value-of select="' simpletable'"/>
    </xsl:if>

    <xsl:if test="@class='topic/strow'">
      <xsl:value-of select="' strow'"/>
    </xsl:if>

    <xsl:if test="@class='topic/sthead'">
      <xsl:value-of select="' sthead'"/>
    </xsl:if>

    <xsl:if test="@class='topic/stentry' and ../@class='topic/sthead'">
      <xsl:value-of select="' sthead_stentry'"/>
    </xsl:if>

    <xsl:if test="@class='topic/stentry' and ../@class='topic/strow'">
      <xsl:value-of select="' strow_stentry'"/>
    </xsl:if>

    <xsl:if test="@class='hi-d/sup'">
      <xsl:value-of select="' sup'"/>
    </xsl:if>

    <xsl:if test="@class='hi-d/sub'">
      <xsl:value-of select="' sub'"/>
    </xsl:if>

    <xsl:if test="@valign='baseline'">
      <xsl:value-of select="' valign_baseline'"/>
    </xsl:if>

    <xsl:if test="@valign='middle'">
      <xsl:value-of select="' valign_middle'"/>
    </xsl:if>

    <xsl:if test="@valign='top'">
      <xsl:value-of select="' valign_top'"/>
    </xsl:if>

    <xsl:if test="@valign='bottom'">
      <xsl:value-of select="' valign_bottom'"/>
    </xsl:if>

    <xsl:if test="@align='left'">
      <xsl:value-of select="' align_left'"/>
    </xsl:if>

    <xsl:if test="@align='right'">
      <xsl:value-of select="' align_right'"/>
    </xsl:if>

    <xsl:if test="@align='bottom'">
      <xsl:value-of select="' align_center'"/>
    </xsl:if>

    <xsl:if test="@frame='box' or @frame='border' or @frame='all'">
      <xsl:value-of select="' border_box'"/>
    </xsl:if>

    <xsl:if test="@frame='hsides' or @frame='topbot'">
      <xsl:value-of select="' border_top_bottom'"/>
    </xsl:if>

    <xsl:if test="@frame='vsides' or @frame='sides'">
      <xsl:value-of select="' border_sides'"/>
    </xsl:if>

    <xsl:if test="@frame='lhs'">
      <xsl:value-of select="' border_lhs'"/>
    </xsl:if>

    <xsl:if test="@frame='rhs'">
      <xsl:value-of select="' border_rhs'"/>
    </xsl:if>

    <xsl:if test="@frame='bottom'">
      <xsl:value-of select="' border_bottom'"/>
    </xsl:if>

    <xsl:if test="@frame='top'">
      <xsl:value-of select="' border_top'"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="AddInlineDisplayStyle">
    <xsl:attribute name="displayStyle">
      <xsl:value-of select="'inline'"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="AddBlockDisplayStyle">
    <xsl:attribute name="displayStyle">
      <xsl:value-of select="'block'"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="AddNoDisplayStyle">
    <xsl:attribute name="displayStyle">
      <xsl:value-of select="'none'"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="title">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[local-name()!='class']"/>
      <xsl:variable name="depth" select="count(ancestor::*)"/>
      <xsl:attribute name="class">
        <!--section title is separate everything else is a heading-->
        <xsl:choose>
          <xsl:when test="name(..)='section'">
            <xsl:value-of select="'section_title'"/>
          </xsl:when>
          <xsl:when test="name(..)='table'">
            <xsl:value-of select="'table_title'"/>
          </xsl:when>
          <xsl:when test="name(..)='pnum'">
            <xsl:value-of select="'pnum-title'"/>
          </xsl:when>
          <xsl:otherwise>
            <!--everything have their own heading depnding on the root element-->
            <xsl:choose>
              <xsl:when test="/qa">
                <xsl:value-of select="concat('qa_heading',$depth)"/>
              </xsl:when>
              <xsl:when test="/dtl-general">
                <xsl:value-of select="concat('dtl-general_heading',$depth)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('heading',$depth)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>

      <xsl:attribute name="displayStyle">
        <xsl:choose>
          <xsl:when test="name(..)='pnum' or name(..)='qa'">
            <xsl:value-of select="'inline'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'block'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="ul[@outputclass='simple']">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[local-name()!='class']"/>
      <xsl:attribute name="class">
        <xsl:value-of select="'ul_simple'"/>
        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="ol|ul">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[local-name()!='class']"/>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="ancestor::*[name()='table']">
            <xsl:value-of select="'table_list'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="name()"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="ul/li">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[local-name()!='class']"/>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="ancestor::*[name()='li']">
            <!--second level list-->
            <xsl:value-of select="'ul_li_ul_li'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'ul_li'"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="ol/li">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[local-name()!='class']"/>
      <xsl:attribute name="class">
        <!--separate the specific bullets-->
        <xsl:choose>
          <xsl:when test="../@outputclass='decimal'">
            <xsl:value-of select="'ol_decimal_li'"/>
          </xsl:when>
          <xsl:when test="../@outputclass='lower-alpha'">
            <xsl:value-of select="'ol_lower-alpha_li'"/>
          </xsl:when>
          <xsl:when test="../@outputclass='upper-alpha'">
            <xsl:value-of select="'ol_upper-alpha_li'"/>
          </xsl:when>
          <xsl:when test="../@outputclass='lower-roman'">
            <xsl:value-of select="'ol_lower-roman_li'"/>
          </xsl:when>
          <xsl:when test="../@outputclass='upper-roman'">
            <xsl:value-of select="'ol_upper-roman_li'"/>
          </xsl:when>
          <xsl:when test="../@outputclass='static'">
            <xsl:value-of select="'ol_outputclass_static_li'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="ancestor::*[name()='li']">
                <!--second level list-->
                <xsl:value-of select="'ol_li_ol_li'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'ol_li'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="sl/sli">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[local-name()!='class']"/>
      <xsl:attribute name="class">
        <xsl:value-of select="'sl_sli'"/>
        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="policy-text">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[local-name()!='class']"/>
      <xsl:attribute name="class">
        <xsl:value-of select="'dtl_policy_text'"/>
        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="linklist/title">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[local-name()!='class']"/>
      <xsl:attribute name="class">
        <xsl:value-of select="'linklist_title'"/>
        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>
      <xsl:call-template name="AddBlockDisplayStyle"/>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="p">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[local-name()!='class']"/>

      <xsl:variable name="classByParent">
        <xsl:choose>
          <xsl:when test="name(..)='fn'">
            <xsl:value-of select="'fn_p'"/>
          </xsl:when>
          <xsl:when test="name(..)='li'">
            <xsl:choose>
              <xsl:when test="name(ancestor::*)='subsection'">
                <xsl:value-of select="' subsection_li_p'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="' li_p'"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="name(preceding-sibling::*)='linum'">
              <xsl:value-of select="' linum_adjacent_p'"/>
            </xsl:if>
          </xsl:when>
          <xsl:when test="name(..)='letter-report'">
            <xsl:value-of select="'letter-report_p'"/>
          </xsl:when>
          <xsl:when test="name(..)='qa-source'">
            <xsl:value-of select="'qa-source_p'"/>
          </xsl:when>
          <xsl:when test="name(..)='entry'">
            <xsl:choose>
              <xsl:when test="ancestor::*[name()='guidance-example']">
                <xsl:value-of select="'guidance-example_entry_p'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'entry_p'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="name(..)='para' and name(../..)='paras'">
            <xsl:value-of select="'paras_para_p'"/>
          </xsl:when>
          <xsl:when test="name(..)='policy-text'">
            <xsl:value-of select="'policy-text_p'"/>
          </xsl:when>
          <xsl:when test="name(..)='guidance-text'">
            <xsl:value-of select="'guidance-text_p'"/>
          </xsl:when>
          <xsl:when test="name(..)='lq'">
            <xsl:value-of select="'lq_p'"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="classBySibling">
        <xsl:choose>
          <!--adjacent to pnum-->
          <xsl:when test="name(preceding-sibling::*[1])='pnum'">
            <xsl:value-of select="'pnum_adjacent_p'"/>
          </xsl:when>
          <!--adjacent to p-->
          <xsl:when test="name(preceding-sibling::*[1])='p'">
            <xsl:choose>
              <xsl:when test="name(..)='li'">
                <xsl:value-of select="'li_p_adjacent_p'"/>
              </xsl:when>
              <xsl:when test="name(..)='entry'">
                <xsl:value-of select="'entry_p_adjacent_p'"/>
              </xsl:when>
              <xsl:when test="name(..)='fn'">
                <xsl:value-of select="'fn_p_adjacent_p'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'p_adjacent_p'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <!--adjacent to letter-report-->
          <xsl:when test="name(preceding-sibling::*[1])='letter-report'">
            <xsl:value-of select="'letter-report_adjacent_p'"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <xsl:attribute name="displayStyle">
        <xsl:choose>
          <xsl:when test="$classByParent='pnum_adjacent_p' or $classBySibling='pnum_adjacent_p' or
									$classByParent='policy-text_p' or $classBySibling='policy-text_p' or
									$classByParent='guidance-text_p' or $classBySibling='guidance-text_p' or
									$classByParent='subsection_li_p' or $classBySibling='subsection_li_p' or
									$classByParent='fn_p' or $classBySibling='fn_p' or $classByParent='linum_p'">
            <xsl:value-of select="'inline'"/>
          </xsl:when>
          <xsl:when test="$classByParent='p' or $classBySibling='p' or
									$classByParent='paras_para_p' or $classBySibling='paras_para_p' or
									$classByParent='p_adjacent_p' or $classBySibling='p_adjacent_p' or
									$classByParent='fn_p_adjacent_p' or $classBySibling='fn_p_adjacent_p' or
									$classByParent='qa-source_p' or $classBySibling='qa-source_p' or
									$classByParent='entry_p' or $classBySibling='entry_p' or
									$classByParent='entry_p_adjacent_p' or $classBySibling='entry_p_adjacent_p' or
									$classByParent='li_p' or $classBySibling='li_p' or
									$classByParent='li_p_adjacent_p' or $classBySibling='li_p_adjacent_p'">
            <xsl:value-of select="'block'"/>
          </xsl:when>
          <!--Dependent on parent,so not sure:letter-report_p,letter-report_adjacent_p-->
        </xsl:choose>
      </xsl:attribute>

      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="$classByParent!=$empty_string and $classBySibling!=$empty_string">
            <xsl:value-of select="concat($classByParent,' ',$classBySibling)"/>
          </xsl:when>
          <xsl:when test="$classByParent!=$empty_string and $classBySibling=$empty_string">
            <xsl:value-of select="$classByParent"/>
          </xsl:when>
          <xsl:when test="$classByParent=$empty_string and $classBySibling!=$empty_string">
            <xsl:value-of select="$classBySibling"/>
          </xsl:when>
        </xsl:choose>
        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>

      <xsl:attribute name="xml:space">
        <xsl:value-of select="'preserve'"/>
      </xsl:attribute>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="policy-body/pnum">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[local-name()!='class']"/>
      <xsl:attribute name="class">
        <xsl:value-of select="'policy-body_pnum'"/>
        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>
      <xsl:call-template name="AddInlineDisplayStyle"/>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="subsection//pnum">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[local-name()!='class']"/>
      <xsl:attribute name="class">
        <xsl:value-of select="'subsection_pnum'"/>
        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>
      <xsl:call-template name="AddInlineDisplayStyle"/>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="subsection//sfragment">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[local-name()!='class']"/>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="name(preceding-sibling::*)='ol'">
            <xsl:value-of select="'ol_adjacent_sfragment'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'sfragment'"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>
      <xsl:call-template name ="AddBlockDisplayStyle"/>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="pnum">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[local-name()!='class']"/>
      <xsl:attribute name="class">
        <xsl:value-of select="'pnum'"/>
        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>
      <xsl:call-template name="AddInlineDisplayStyle"/>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="note">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[local-name()!='class']"/>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="@othertype='amended'">
            <xsl:value-of select="'note_type_amended'"/>
          </xsl:when>
          <xsl:when test="@othertype='added'">
            <xsl:value-of select="'note_type_added'"/>
          </xsl:when>
          <xsl:when test="@othertype='deleted'">
            <xsl:value-of select="'note_type_deleted'"/>
          </xsl:when>
          <xsl:when test="@othertype='renumbered'">
            <xsl:value-of select="'note_type_renumbered'"/>
          </xsl:when>
        </xsl:choose>
        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="table">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[local-name()!='class']"/>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="@frame='none'">
            <xsl:value-of select="'table_no_frame'"/>
          </xsl:when>
          <xsl:when test="@frame='top'">
            <xsl:value-of select="'table_top_frame'"/>
          </xsl:when>
          <xsl:when test="@frame='bottom'">
            <xsl:value-of select="'table_bottom_frame'"/>
          </xsl:when>
          <xsl:when test="@frame='topbot'">
            <xsl:value-of select="'table_topbot_frame'"/>
          </xsl:when>
          <xsl:when test="@frame='sides'">
            <xsl:value-of select="'table_sides_frame'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'table'"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="@border">
          <xsl:if test="@rules='none'">
            <xsl:value-of select="' table_border_rules_none'"/>
          </xsl:if>
          <xsl:if test="@rules='all'">
            <xsl:value-of select="' table_border_rules_all'"/>
          </xsl:if>
          <xsl:if test="@rules='rows'">
            <xsl:value-of select="' table_border_rules_rows'"/>
          </xsl:if>
          <xsl:if test="@rules='cols'">
            <xsl:value-of select="' table_border_rules_cols'"/>
          </xsl:if>
        </xsl:if>
        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>

      <xsl:call-template name="AddBlockDisplayStyle"/>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="tgroup">
    <tgroup>
      <xsl:if test="../@pgwide=1">
        <xsl:attribute name="width">100%</xsl:attribute>
      </xsl:if>

      <xsl:if test="@align">
        <xsl:attribute name="align">
          <xsl:value-of select="@align"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:variable name="colgroup">
        <colgroup>
          <xsl:call-template name="generate_colgroup">
            <xsl:with-param name="cols" select="@cols"/>
          </xsl:call-template>
        </colgroup>
      </xsl:variable>

      <xsl:attribute name="width">100%</xsl:attribute>

      <xsl:copy-of select="$colgroup"/>

      <xsl:apply-templates/>

    </tgroup>
  </xsl:template>

  <xsl:template match="thead|tfoot">
    <xsl:element name="{name(.)}">
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:if test="@align">
        <xsl:attribute name="align">
          <xsl:value-of select="@align"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@char">
        <xsl:attribute name="char">
          <xsl:value-of select="@char"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@charoff">
        <xsl:attribute name="charoff">
          <xsl:value-of select="@charoff"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@valign">
        <xsl:attribute name="valign">
          <xsl:value-of select="@valign"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tbody">
    <tbody>
      <xsl:attribute name="class">
        <xsl:value-of select="'tbody'"/>
      </xsl:attribute>
      <xsl:if test="@align">
        <xsl:attribute name="align">
          <xsl:value-of select="@align"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@char">
        <xsl:attribute name="char">
          <xsl:value-of select="@char"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@charoff">
        <xsl:attribute name="charoff">
          <xsl:value-of select="@charoff"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@valign">
        <xsl:attribute name="valign">
          <xsl:value-of select="@valign"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:apply-templates/>
    </tbody>
  </xsl:template>

  <xsl:template match="row">
    <tr>
      <xsl:attribute name="class">
        <xsl:value-of select="'row'"/>
      </xsl:attribute>
      <xsl:if test="@align">
        <xsl:attribute name="align">
          <xsl:value-of select="@align"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@char">
        <xsl:attribute name="char">
          <xsl:value-of select="@char"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@charoff">
        <xsl:attribute name="charoff">
          <xsl:value-of select="@charoff"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@valign">
        <xsl:attribute name="valign">
          <xsl:value-of select="@valign"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <xsl:template match="thead/row/entry">
    <xsl:call-template name="process_cell">
      <xsl:with-param name="cellgi">th</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tbody/row/entry">
    <xsl:call-template name="process_cell">
      <xsl:with-param name="cellgi">td</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tfoot/row/entry">
    <xsl:call-template name="process_cell">
      <xsl:with-param name="cellgi">th</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="process_cell">
    <xsl:param name="cellgi">td</xsl:param>

    <xsl:variable name="empty_cell" select="count(node()) = 0"/>

    <xsl:variable name="entry_colnum">
      <xsl:call-template name="entry_colnum"/>
    </xsl:variable>

    <xsl:if test="$entry_colnum != ''">
      <xsl:variable name="prev_entry" select="preceding-sibling::*[1]"/>
      <xsl:variable name="prev_entry_ending_column">
        <xsl:choose>
          <xsl:when test="$prev_entry">
            <xsl:call-template name="entry_ending_colnum">
              <xsl:with-param name="entry" select="$prev_entry"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="prev_morerows_entry" select="../preceding-sibling::*/child::entry[number(@morerows)>0]"/>
      <xsl:variable name="prev_morerows_entry_ending_column">
        <xsl:call-template name="last_prev_morerows_entry_colnum">
          <xsl:with-param name="prev_morerows_entry" select="$prev_morerows_entry"/>
          <xsl:with-param name="current_colnum" select="$entry_colnum" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="prev_ending_colnum">
        <xsl:value-of select="$prev_entry_ending_column + $prev_morerows_entry_ending_column"/>
      </xsl:variable>

      <xsl:call-template name="add-empty-entries">
        <xsl:with-param name="number">
          <xsl:choose>
            <xsl:when test="$prev_ending_colnum = ''">0</xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$entry_colnum - $prev_ending_colnum - 1"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <xsl:element name="{$cellgi}">

      <xsl:call-template name="AddEntryClass">
        <xsl:with-param name="cellgi" select="$cellgi"/>
        <xsl:with-param name="colnum" select="$entry_colnum"/>
      </xsl:call-template>

      <xsl:if test="@spanname">
        <xsl:variable name="namest" select="ancestor::tgroup/spanspec[@spanname=./@spanname]/@namest"/>
        <xsl:variable name="nameend" select="ancestor::tgroup/spanspec[@spanname=./@spanname]/@nameend"/>
        <xsl:variable name="colst" select="ancestor::*[colspec/@colname=$namest]/colspec[@colname=$namest]/@colnum"/>
        <xsl:variable name="colend" select="ancestor::*[colspec/@colname=$nameend]/colspec[@colname=$nameend]/@colnum"/>
        <xsl:attribute name="colspan">
          <xsl:value-of select="number($colend) -number($colst) + 1"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="@morerows">
        <xsl:attribute name="rowspan">
          <xsl:value-of select="@morerows+1"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@namest">
        <xsl:attribute name="colspan">
          <xsl:call-template name="calculate_colspan"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@align">
        <xsl:attribute name="align">
          <xsl:value-of select="@align"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@char">
        <xsl:attribute name="char">
          <xsl:value-of select="@char"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@charoff">
        <xsl:attribute name="charoff">
          <xsl:value-of select="@charoff"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@valign">
        <xsl:attribute name="valign">
          <xsl:value-of select="@valign"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="not(preceding-sibling::*)
                  and ancestor::row/@id">
        <a name="{ancestor::row/@id}"/>
      </xsl:if>

      <xsl:if test="@id">
        <a name="{@id}"/>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="$empty_cell">
          <xsl:text>&#160;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template name="AddEntryClass">
    <xsl:param name="cellgi"/>
    <xsl:param name="colnum"/>
    <xsl:variable name="is_first_column" select="$colnum=1"/>
    <xsl:variable name="is_last_column" select="$colnum>=count(../entry)"/>
    <xsl:variable name="is_last_row" select="count(../preceding-sibling::row) +1>=count(../../row)"/>
    <xsl:variable name="is_first_row" select="count(../preceding-sibling::row)=0"/>
    <xsl:variable name="has_headers" select="count(../../../thead/row)>0"/>
    <xsl:variable name="has_non_header_rows" select="count(../../../tbody/row)>0"/>

    <xsl:attribute name="class">
      <xsl:choose>
        <xsl:when test="$cellgi ='th'">
          <xsl:choose>
            <xsl:when test="ancestor::table[@frame='none']">
              <xsl:value-of select="'thead_row_entry_no_frame'"/>
            </xsl:when>
            <xsl:when test="ancestor::table[@frame='topbot']">
              <xsl:choose>
                <xsl:when test="$is_first_column='true'">
                  <xsl:value-of select="'thead_row_entry_no_left_side'"/>
                </xsl:when>
                <xsl:when test="$is_last_column='true'">
                  <xsl:value-of select="'thead_row_entry_no_right_side'"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'thead_row_entry'"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="ancestor::table[@frame='bottom']">
              <xsl:value-of select="'thead_row_entry_no_top'"/>
            </xsl:when>
            <xsl:when test="ancestor::table[@frame='sides']">
              <xsl:choose>
                <xsl:when test="$has_non_header_rows ='true'">
                  <xsl:value-of select="'thead_row_entry_no_top'"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'thead_row_entry_no_top_no_bottom'"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="ancestor::table[@frame='top']">
              <xsl:choose>
                <xsl:when test="$has_non_header_rows!='true'">
                  <xsl:value-of select="'thead_row_entry_no_bottom'"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'thead_row_entry'"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'thead_row_entry'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="ancestor::table[@frame='none']">
              <xsl:value-of select="'entry_no_frame'"/>
            </xsl:when>
            <xsl:when test="ancestor::table[@frame='topbot']">
              <xsl:choose>
                <xsl:when test="$is_first_column='true'">
                  <xsl:value-of select="'entry_no_left_side'"/>
                </xsl:when>
                <xsl:when test="$is_last_column='true'">
                  <xsl:value-of select="'entry_no_right_side'"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'entry'"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="ancestor::table[@frame='top']">
              <xsl:choose>
                <xsl:when test="$is_last_row='true'">
                  <xsl:value-of select="'entry_no_bottom'"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'entry'"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="ancestor::table[@frame='sides']">
              <xsl:choose>
                <xsl:when test="$is_first_row='true' and $has_headers!='true'">
                  <xsl:value-of select="'entry_no_top'"/>
                </xsl:when>
                <xsl:when test="$is_last_row='true'">
                  <xsl:value-of select="'entry_no_bottom'"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'entry'"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="ancestor::table[@frame='bottom']">
              <xsl:choose>
                <xsl:when test="$is_first_row='true' and $has_headers!='true'">
                  <xsl:value-of select="'entry_no_top'"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'entry'"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'entry'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="ancestor::*[@colsep='0']">
        <xsl:value-of select="' no_colsep'"/>
      </xsl:if>
      <xsl:if test="ancestor::*[@rowsep='0']">
        <xsl:value-of select="' no_rowsep'"/>
      </xsl:if>
      <xsl:call-template name="AddOtherClasses"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="last_prev_morerows_entry_colnum">
    <xsl:param name="prev_morerows_entry"/>
    <xsl:param name="current_colnum" />

    <xsl:variable name="sibling_entry_ending_colnum">
      <xsl:choose>
        <xsl:when test="preceding-sibling::*[1]">
          <xsl:call-template name="entry_ending_colnum">
            <xsl:with-param name="entry" select="preceding-sibling::*[1]"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>-1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$sibling_entry_ending_colnum = $current_colnum - 1">0</xsl:when>
      <xsl:when test="count($prev_morerows_entry)>0">
        <xsl:for-each select="$prev_morerows_entry/.">
          <xsl:variable name="entry_ending_colnum">
            <xsl:call-template name="entry_ending_colnum"/>
          </xsl:variable>
          <xsl:if test="$entry_ending_colnum = $current_colnum - 1 or ($entry_ending_colnum =1 and $current_colnum = 1)">
            <xsl:value-of select="$entry_ending_colnum"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="add-empty-entries">
    <xsl:param name="number" select="'0'"/>
    <xsl:choose>
      <xsl:when test="$number &lt;= 0 or not(number($number))"></xsl:when>
      <xsl:otherwise>
        <td>&#160;</td>
        <xsl:call-template name="add-empty-entries">
          <xsl:with-param name="number" select="$number - 1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="entry_colnum">
    <xsl:param name="entry" select="."/>

    <xsl:choose>
      <xsl:when test="$entry/@colname">
        <xsl:variable name="colname" select="$entry/@colname"/>
        <xsl:variable name="colspec" select="$entry/ancestor::tgroup/colspec[@colname=$colname]"/>
        <xsl:call-template name="colspec_colnum">
          <xsl:with-param name="colspec" select="$colspec"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$entry/@namest">
        <xsl:variable name="namest" select="$entry/@namest"/>
        <xsl:variable name="colspec" select="$entry/ancestor::tgroup/colspec[@colname=$namest]"/>
        <xsl:call-template name="colspec_colnum">
          <xsl:with-param name="colspec" select="$colspec"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="count($entry/preceding-sibling::*) = 0">1</xsl:when>
      <xsl:otherwise>
        <xsl:variable name="pcol">
          <xsl:call-template name="entry_ending_colnum">
            <xsl:with-param name="entry" select="$entry/preceding-sibling::*[1]"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$pcol + 1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="entry_ending_colnum">
    <xsl:param name="entry" select="."/>

    <xsl:choose>
      <xsl:when test="$entry/@nameend">
        <xsl:variable name="nameend" select="$entry/@nameend"/>
        <xsl:variable name="colspec" select="$entry/ancestor::tgroup/colspec[@colname=$nameend]"/>
        <xsl:call-template name="colspec_colnum">
          <xsl:with-param name="colspec" select="$colspec"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$entry/@colname">
        <xsl:variable name="colname" select="$entry/@colname"/>
        <xsl:variable name="colspec" select="$entry/ancestor::tgroup/colspec[@colname=$colname]"/>
        <xsl:call-template name="colspec_colnum">
          <xsl:with-param name="colspec" select="$colspec"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="count($entry/preceding-sibling::*) = 0">1</xsl:when>
      <xsl:otherwise>
        <xsl:variable name="pcol">
          <xsl:call-template name="entry_ending_colnum">
            <xsl:with-param name="entry" select="$entry/preceding-sibling::*[1]"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$pcol + 1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="colspec_colnum">
    <xsl:param name="colspec" select="."/>
    <xsl:choose>
      <xsl:when test="$colspec/@colnum">
        <xsl:value-of select="$colspec/@colnum"/>
      </xsl:when>
      <xsl:when test="$colspec/preceding-sibling::colspec">
        <xsl:variable name="prec_colspec_colnum">
          <xsl:call-template name="colspec_colnum">
            <xsl:with-param name="colspec"
										select="$colspec/preceding-sibling::colspec[1]"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$prec_colspec_colnum + 1"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="generate_colgroup">
    <xsl:param name="cols" select="1"/>
    <xsl:param name="count" select="1"/>
    <xsl:choose>
      <xsl:when test="$count>$cols"></xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="generate_col">
          <xsl:with-param name="countcol" select="$count"/>
        </xsl:call-template>
        <xsl:call-template name="generate_colgroup">
          <xsl:with-param name="cols" select="$cols"/>
          <xsl:with-param name="count" select="$count+1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="generate_col">
    <xsl:param name="countcol">1</xsl:param>
    <xsl:param name="colspecs" select="./colspec"/>
    <xsl:param name="count">1</xsl:param>
    <xsl:param name="colnum">1</xsl:param>

    <xsl:choose>
      <xsl:when test="$count>count($colspecs)">
        <col/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="colspec" select="$colspecs[$count=position()]"/>
        <xsl:variable name="colspec_colnum">
          <xsl:choose>
            <xsl:when test="$colspec/@colnum">
              <xsl:value-of select="$colspec/@colnum"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$colnum"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="$colspec_colnum=$countcol">
            <col>
              <xsl:attribute name="class">
                <xsl:value-of select="'col'"/>
              </xsl:attribute>
              <xsl:if test="$colspec/@align">
                <xsl:attribute name="align">
                  <xsl:value-of select="$colspec/@align"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="$colspec/@char">
                <xsl:attribute name="char">
                  <xsl:value-of select="$colspec/@char"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="$colspec/@charoff">
                <xsl:attribute name="charoff">
                  <xsl:value-of select="$colspec/@charoff"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="$colspec/@colwidth">
                <xsl:attribute name="width">
                  <xsl:variable name="currentColumn" select="$count"/>
                  <xsl:variable name="totalWidthValue">
                    <xsl:call-template name="total">
                      <xsl:with-param name="nodes" select="$colspecs"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:variable name="currentWidthValue">
                    <xsl:choose>
                      <xsl:when test="contains($colspec/@colwidth,'in')">
                        <xsl:value-of select ="normalize-space(translate($colspec/@colwidth,'in','  '))"/>
                      </xsl:when>
                      <xsl:when test="contains($colspec/@colwidth,'*')">
                        <xsl:value-of select ="normalize-space(translate($colspec/@colwidth,'*','  '))"/>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:variable>
                  <xsl:variable name="resultWidth" select="($currentWidthValue div $totalWidthValue)*100"/>
                  <xsl:value-of select="concat($resultWidth,'%')"/>
                </xsl:attribute>
              </xsl:if>
            </col>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="generate_col">
              <xsl:with-param name="countcol" select="$countcol"/>
              <xsl:with-param name="colspecs" select="$colspecs"/>
              <xsl:with-param name="count" select="$count+1"/>
              <xsl:with-param name="colnum">
                <xsl:choose>
                  <xsl:when test="$colspec/@colnum">
                    <xsl:value-of select="$colspec/@colnum + 1"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$colnum + 1"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="total">
    <xsl:param name="nodes" />
    <xsl:variable name="currentValue" >
      <xsl:choose>
        <xsl:when test="contains($nodes[1]/@colwidth,'in')">
          <xsl:value-of select ="normalize-space(translate($nodes[1]/@colwidth,'in','  '))"/>
        </xsl:when>
        <xsl:when test="contains($nodes[1]/@colwidth,'*')">
          <xsl:value-of select ="normalize-space(translate($nodes[1]/@colwidth,'*','  '))"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <!-- either there is something to calculate... -->
      <xsl:when test="number($currentValue)">
        <xsl:variable name="subtotal">
          <xsl:call-template name="total">
            <xsl:with-param name="nodes" select="$nodes[position() &gt; 1]" />
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$currentValue + $subtotal" />
      </xsl:when>
      <!-- ...or we assume 0 -->
      <xsl:otherwise>
        <xsl:value-of select="0" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="colspec_colwidth">
    <!-- when this macro is called, the current context must be an entry -->
    <xsl:param name="colname"></xsl:param>
    <!-- .. = row, ../.. = thead|tbody, ../../.. = tgroup -->
    <xsl:param name="colspecs" select="../../../../tgroup/colspec"/>
    <xsl:param name="count">1</xsl:param>
    <xsl:choose>
      <xsl:when test="$count>count($colspecs)"></xsl:when>
      <xsl:otherwise>
        <xsl:variable name="colspec" select="$colspecs[$count=position()]"/>
        <xsl:choose>
          <xsl:when test="$colspec/@colname=$colname">
            <xsl:value-of select="$colspec/@colwidth"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="colspec_colwidth">
              <xsl:with-param name="colname" select="$colname"/>
              <xsl:with-param name="colspecs" select="$colspecs"/>
              <xsl:with-param name="count" select="$count+1"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="calculate_colspan">
    <xsl:param name="entry" select="."/>
    <xsl:variable name="namest" select="$entry/@namest"/>
    <xsl:variable name="nameend" select="$entry/@nameend"/>

    <xsl:variable name="scol">
      <xsl:call-template name="colspec_colnum">
        <xsl:with-param name="colspec"
		  select="$entry/ancestor::tgroup/colspec[@colname=$namest]"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="ecol">
      <xsl:call-template name="colspec_colnum">
        <xsl:with-param name="colspec"

		  select="$entry/ancestor::tgroup/colspec[@colname=$nameend]"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$ecol - $scol + 1"/>
  </xsl:template>

  <xsl:template name="stringReplace">
    <xsl:param name ="source"/>
    <xsl:param name ="match"/>
    <xsl:param name ="replace"/>
    <xsl:choose>
      <xsl:when test="contains($source,$match)">
        <xsl:value-of select="concat(substring-before($source,$match),$replace)"/>
        <xsl:call-template name="stringReplace">
          <xsl:with-param name="source" select="substring-after($source,$match)"/>
          <xsl:with-param name="match" select="$match"/>
          <xsl:with-param name="replace" select="$replace"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$source"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="table/desc">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[local-name()!='class']"/>
      <xsl:attribute name="class">
        <xsl:value-of select="'table_desc'"/>
        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>
      <xsl:call-template name="AddBlockDisplayStyle"/>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="fn">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[local-name()!='class' and local-name()!='name' and local-name()!='id']"/>
      <xsl:attribute name="class">
        <xsl:value-of select="'fn'"/>
        <xsl:call-template name="AddOtherClasses"/>
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:choose>
          <xsl:when test="normalize-space(@callout)!=$empty_string and number(normalize-space(@callout))!='NaN'">
            <xsl:value-of select="@callout"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="count(preceding::fn)+ 1 
								  - count(preceding::fn[@callout!=$empty_string])"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="count(preceding::fn)+ 1"/>
      </xsl:attribute>
      <xsl:call-template name="AddInlineDisplayStyle"/>
      <xsl:apply-templates select="*|comment()|processing-instruction()|text()" />
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
