<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

    <xsl:variable name="i18n.bt10" select="'Routing ID'"/>
    <xsl:variable name="i18n.bt44" select="'Name'"/>
    <xsl:variable name="i18n.title" select="'XRechnung'"/>
    <xsl:variable name="i18n.overview" select="'Overview'"/>
    <xsl:variable name="i18n.items" select="'Items'"/>
    <xsl:variable name="i18n.information" select="'Information'"/>
    <xsl:variable name="i18n.attachments" select="'Attachments'"/>
    <xsl:variable name="i18n.history" select="'History'"/>
    <xsl:variable name="i18n.disclaimer" select="'We accept no liability for the correctness of the data'"/>
    <xsl:variable name="i18n.recipientInfo" select="'Buyer Information'"/>
    <xsl:variable name="i18n.bt50" select="'Street / house number'"/>
    <xsl:variable name="i18n.bt51" select="'PO Box'"/>
    <xsl:variable name="i18n.bt163" select="'Address Addition'"/>
    <xsl:variable name="i18n.bt53" select="'Postcode'"/>
    <xsl:variable name="i18n.bt52" select="'Place'"/>
    <xsl:variable name="i18n.bt54" select="'State/Province'"/>
    <xsl:variable name="i18n.bt55" select="'Country'"/>
    <xsl:variable name="i18n.bt46" select="'ID'"/>
    <xsl:variable name="i18n.bt46-id" select="'ID scheme'"/>
    <xsl:variable name="i18n.bt56" select="'Name'"/>
    <xsl:variable name="i18n.bt57" select="'Phone'"/>
    <xsl:variable name="i18n.bt58" select="'E-mail address'"/>
    <xsl:variable name="i18n.bt27" select="'Company name'"/>
    <xsl:variable name="i18n.bt35" select="'Street / house number'"/>
    <xsl:variable name="i18n.bt36" select="'PO Box'"/>
    <xsl:variable name="i18n.bt162" select="'Address Addition'"/>
    <xsl:variable name="i18n.bt38" select="'Code postal'"/>
    <xsl:variable name="i18n.bt37" select="'Place'"/>
    <xsl:variable name="i18n.bt39" select="'State/Province'"/>
    <xsl:variable name="i18n.bt40" select="'Country code'"/>
    <xsl:variable name="i18n.bt29" select="'ID'"/>
    <xsl:variable name="i18n.bt29-id" select="'ID scheme'"/>
    <xsl:variable name="i18n.bt41" select="'Name'"/>
    <xsl:variable name="i18n.bt42" select="'Phone'"/>
    <xsl:variable name="i18n.bt43" select="'E-mail address'"/>
    <xsl:variable name="i18n.bt1" select="'Seller Information'"/>
    <xsl:variable name="i18n.bt2" select="'Invoice date'"/>
    <xsl:variable name="i18n.details" select="'Invoice details'"/>
    <xsl:variable name="i18n.period" select="'Billing period'"/>
    <xsl:variable name="i18n.bt3" select="'Invoice type'"/>
    <xsl:variable name="i18n.bt5" select="'Currency'"/>
    <xsl:variable name="i18n.bt73" select="'from'"/>
    <xsl:variable name="i18n.bt74" select="'to'"/>
    <xsl:variable name="i18n.bt11" select="'Project number'"/>
    <xsl:variable name="i18n.bt12" select="'Contract Number'"/>
    <xsl:variable name="i18n.bt13" select="'Order number'"/>
    <xsl:variable name="i18n.bt14" select="'Order number'"/>
    <xsl:variable name="i18n.bt25" select="'Invoice number'"/>
    <xsl:variable name="i18n.bt26" select="'Invoice date'"/>
    <xsl:variable name="i18n.bg22" select="'Total amounts of the invoice'"/>
    <xsl:variable name="i18n.bt106" select="'Line total'"/>
    <xsl:variable name="i18n.bt107" select="'Total discounts'"/>
    <xsl:variable name="i18n.bt108" select="'Total charges'"/>
    <xsl:variable name="i18n.bt109" select="'Grand total'"/>
    <xsl:variable name="i18n.bt110" select="'VAT amount'"/>
    <xsl:variable name="i18n.bt111" select="'Total VAT'"/>
    <xsl:variable name="i18n.bt112" select="'Grand total'"/>
    <xsl:variable name="i18n.bt113" select="'Amount paid'"/>
    <xsl:variable name="i18n.bt114" select="'rounding amount'"/>
    <xsl:variable name="i18n.bt115" select="'Amount Due'"/>
    <xsl:variable name="i18n.bg23" select="'Breakdown of VAT at invoice level'"/>
    <xsl:variable name="i18n.bt118" select="'VAT category'"/>
    <xsl:variable name="i18n.bt116" select="'Grand total'"/>
    <xsl:variable name="i18n.bt119" select="'VAT rate'"/>
    <xsl:variable name="i18n.bt117" select="'VAT amount'"/>
    <xsl:variable name="i18n.bt120" select="'Reason for exemption:'"/>
    <xsl:variable name="i18n.bt121" select="'ID for the exemption reason:'"/>
    <xsl:variable name="i18n.bg20" select="'Allowance at invoice level'"/>
    <xsl:variable name="i18n.bt95" select="'VAT category of the discount:'"/>
    <xsl:variable name="i18n.bt93" select="'Basic amount'"/>
    <xsl:variable name="i18n.bt94" select="'Percentage'"/>
    <xsl:variable name="i18n.bt92" select="'Allowance'"/>
    <xsl:variable name="i18n.bt96" select="'VAT rate on allowance'"/>
    <xsl:variable name="i18n.bt97" select="'Reason for the allowance'"/>
    <xsl:variable name="i18n.bt98" select="'Document level allowance reason code'"/>
    <xsl:variable name="i18n.bg21" select="'Charge amount at invoice level'"/>
    <xsl:variable name="i18n.bt102" select="'VAT category of the charge amount'"/>
    <xsl:variable name="i18n.bt100" select="'Basic amount'"/>
    <xsl:variable name="i18n.bt101" select="'Percentage'"/>
    <xsl:variable name="i18n.bt99" select="'Charge amount'"/>
    <xsl:variable name="i18n.bt103" select="'VAT rate of the charge amount'"/>
    <xsl:variable name="i18n.bt104" select="'Reason for the charge amount:'"/>
    <xsl:variable name="i18n.bt105" select="'Document level charge reason code'"/>
    <xsl:variable name="i18n.bgx42" select="'Shipping cost'"/>
    <xsl:variable name="i18n.btx274" select="'VAT category of the shipping cost'"/>
    <xsl:variable name="i18n.btx272" select="'Amount'"/>
    <xsl:variable name="i18n.btx273" select="'VAT rate of the shipping cost'"/>
    <xsl:variable name="i18n.btx271" select="'Shipping cost description'"/>
    <xsl:variable name="i18n.bt20" select="'Discount; other payment terms'"/>
    <xsl:variable name="i18n.bt9" select="'Due date'"/>
    <xsl:variable name="i18n.bt81" select="'Code for the means of payment'"/>
    <xsl:variable name="i18n.bt82" select="'Means of payment'"/>
    <xsl:variable name="i18n.bt83" select="'Usage'"/>
    <xsl:variable name="i18n.bg18" select="'Card information'"/>
    <xsl:variable name="i18n.bt87" select="'Card number'"/>
    <xsl:variable name="i18n.bt88" select="'Card holder'"/>
    <xsl:variable name="i18n.bg19" select="'Direct debit'"/>
    <xsl:variable name="i18n.bt89" select="'Mandate Reference No'"/>
    <xsl:variable name="i18n.bt91" select="'IBAN'"/>
    <xsl:variable name="i18n.bt90" select="'Creditor ID'"/>
    <xsl:variable name="i18n.bg17" select="'Transfer'"/>
    <xsl:variable name="i18n.bt85" select="'Account holder'"/>
    <xsl:variable name="i18n.bt84" select="'IBAN'"/>
    <xsl:variable name="i18n.bt86" select="'BIC'"/>
    <xsl:variable name="i18n.bg1" select="'Invoice Comment'"/>
    <xsl:variable name="i18n.bt21" select="'Subject'"/>
    <xsl:variable name="i18n.bt22" select="'Comment'"/>
    <xsl:variable name="i18n.bt126" select="'Line'"/>
    <xsl:variable name="i18n.bt127" select="'Free text'"/>
    <xsl:variable name="i18n.bt128" select="'Object ID'"/>
    <xsl:variable name="i18n.bt128-id" select="'Object ID schema'"/>
    <xsl:variable name="i18n.bt132" select="'Order line number'"/>
    <xsl:variable name="i18n.bt133" select="'Account assignment information'"/>
    <xsl:variable name="i18n.bg26" select="'Billing period'"/>
    <xsl:variable name="i18n.bt134" select="'from'"/>
    <xsl:variable name="i18n.bt135" select="'to'"/>
    <xsl:variable name="i18n.bg29" select="'Price details'"/>
    <xsl:variable name="i18n.bt129" select="'Quantity'"/>
    <xsl:variable name="i18n.bt130" select="'Unit'"/>
    <xsl:variable name="i18n.bt146" select="'Unit price (net)'"/>
    <xsl:variable name="i18n.bt131" select="'Total price (net)'"/>
    <xsl:variable name="i18n.bt147" select="'Discount (net)'"/>
    <xsl:variable name="i18n.bt148" select="'Net list price'"/>
    <xsl:variable name="i18n.bt149" select="'Number of units'"/>
    <xsl:variable name="i18n.bt150" select="'Unit of measure code'"/>
    <xsl:variable name="i18n.bt151" select="'VAT'"/>
    <xsl:variable name="i18n.bt152" select="'VAT rate in percent'"/>
    <xsl:variable name="i18n.bg27" select="'Allowances at line level'"/>
    <xsl:variable name="i18n.bt137" select="'Basic amount (net)'"/>
    <xsl:variable name="i18n.bt138" select="'Percentage'"/>
    <xsl:variable name="i18n.bt136" select="'Allowance (net)'"/>
    <xsl:variable name="i18n.bt139" select="'Reason for allowance'"/>
    <xsl:variable name="i18n.bt140" select="'Code for the reason for the estate'"/>
    <xsl:variable name="i18n.bg28" select="'Charges at invoice line level'"/>
    <xsl:variable name="i18n.bt142" select="'Basic amount (net)'"/>
    <xsl:variable name="i18n.bt143" select="'percentage'"/>
    <xsl:variable name="i18n.bt141" select="'Charge amount (net)'"/>
    <xsl:variable name="i18n.bt144" select="'Reason for the allowance'"/>
    <xsl:variable name="i18n.bt145" select="'Reason code'"/>
    <xsl:variable name="i18n.bg31" select="'Item Information'"/>
    <xsl:variable name="i18n.bt153" select="'Name'"/>
    <xsl:variable name="i18n.bt154" select="'Description'"/>
    <xsl:variable name="i18n.bt155" select="'Part number'"/>
    <xsl:variable name="i18n.bt156" select="'Customer''s material number'"/>
    <xsl:variable name="i18n.bg32" select="'Article properties'"/>
    <xsl:variable name="i18n.bt157" select="'Item ID'"/>
    <xsl:variable name="i18n.bt157-id" select="'Item ID schema'"/>
    <xsl:variable name="i18n.bt158" select="'Item classification code'"/>
    <xsl:variable name="i18n.bt158-id" select="'Identifier to form the schema'"/>
    <xsl:variable name="i18n.bt157-vers-id" select="'Version for creating the schema'"/>
    <xsl:variable name="i18n.bt159" select="'Country of origin code'"/>
    <xsl:variable name="i18n.bg4" select="'Seller Information'"/>
    <xsl:variable name="i18n.bt28" select="'Differing trade name'"/>
    <xsl:variable name="i18n.bt34" select="'Electronic address'"/>
    <xsl:variable name="i18n.bt34-id" select="'Electronic address scheme'"/>
    <xsl:variable name="i18n.bt30" select="'Register number'"/>
    <xsl:variable name="i18n.bt31" select="'VAT ID'"/>
    <xsl:variable name="i18n.bt32" select="'Tax ID'"/>
    <xsl:variable name="i18n.bt32-schema" select="'Tax ID scheme'"/>
    <xsl:variable name="i18n.bt33" select="'Further legal information'"/>
    <xsl:variable name="i18n.bt6" select="'VAT currency code'"/>
    <xsl:variable name="i18n.bg11" select="'seller''s tax representative'"/>
    <xsl:variable name="i18n.bt62" select="'Name'"/>
    <xsl:variable name="i18n.bt64" select="'Street / house number'"/>
    <xsl:variable name="i18n.bt65" select="'PO Box'"/>
    <xsl:variable name="i18n.bt164" select="'Address Addition'"/>
    <xsl:variable name="i18n.bt67" select="'Postcode'"/>
    <xsl:variable name="i18n.bt66" select="'Place'"/>
    <xsl:variable name="i18n.bt68" select="'State/Province'"/>
    <xsl:variable name="i18n.bt69" select="'Country code'"/>
    <xsl:variable name="i18n.bt63" select="'VAT ID'"/>
    <xsl:variable name="i18n.bg7" select="'Buyer Information'"/>
    <xsl:variable name="i18n.bt45" select="'Differing trade name'"/>
    <xsl:variable name="i18n.bt49" select="'E-mail address'"/>
    <xsl:variable name="i18n.bt49-id" select="'Electronic address scheme'"/>
    <xsl:variable name="i18n.bt47" select="'Register number'"/>
    <xsl:variable name="i18n.bt47-id" select="'Scheme of register/register number'"/>
    <xsl:variable name="i18n.bt48" select="'VAT ID'"/>
    <xsl:variable name="i18n.bt7" select="'VAT payday date'"/>
    <xsl:variable name="i18n.bt8" select="'VAT Statement Date Code'"/>
    <xsl:variable name="i18n.bt19" select="'Account assignment information'"/>
    <xsl:variable name="i18n.bg13" select="'Shipping information'"/>
    <xsl:variable name="i18n.bt71" select="'Identification of the place of delivery'"/>
    <xsl:variable name="i18n.bt71-id" select="'ID scheme'"/>
    <xsl:variable name="i18n.bt72" select="'Date of delivery'"/>
    <xsl:variable name="i18n.bt70" select="'Recipient name'"/>
    <xsl:variable name="i18n.bt75" select="'Street / house number'"/>
    <xsl:variable name="i18n.bt76" select="'PO Box'"/>
    <xsl:variable name="i18n.bt165" select="'Address Addition'"/>
    <xsl:variable name="i18n.bt78" select="'Code postal'"/>
    <xsl:variable name="i18n.bt77" select="'Place'"/>
    <xsl:variable name="i18n.bt79" select="'State/Province'"/>
    <xsl:variable name="i18n.bt80" select="'Country'"/>
    <xsl:variable name="i18n.bt17" select="'Assignment number'"/>
    <xsl:variable name="i18n.bt15" select="'Receipt confirmation ID'"/>
    <xsl:variable name="i18n.bt16" select="'Dispatch note ID'"/>
    <xsl:variable name="i18n.bt23" select="'Process ID'"/>
    <xsl:variable name="i18n.bt24" select="'Specification ID'"/>
    <xsl:variable name="i18n.bt18" select="'Object ID'"/>
    <xsl:variable name="i18n.bt18-id" select="'Object ID schema'"/>
    <xsl:variable name="i18n.bg10" select="'Payee other than Seller'"/>
    <xsl:variable name="i18n.bt59" select="'Name'"/>
    <xsl:variable name="i18n.bt60" select="'ID'"/>
    <xsl:variable name="i18n.bt60-id" select="'ID scheme'"/>
    <xsl:variable name="i18n.bt61" select="'Register number'"/>
    <xsl:variable name="i18n.bt61-id" select="'Scheme of register/register number'"/>
    <xsl:variable name="i18n.bg24" select="'Documents justifying the invoice'"/>
    <xsl:variable name="i18n.bt122" select="'ID'"/>
    <xsl:variable name="i18n.bt123" select="'Description'"/>
    <xsl:variable name="i18n.bt124" select="'Reference (e.g. Internet address)'"/>
    <xsl:variable name="i18n.bt125" select="'Attachment'"/>
    <xsl:variable name="i18n.bt125-format" select="'Format of attachment'"/>
    <xsl:variable name="i18n.bt125-name" select="'Name of attachment'"/>
    <xsl:variable name="i18n.historyDate" select="'Date/time'"/>
    <xsl:variable name="i18n.historySubject" select="'Subject'"/>
    <xsl:variable name="i18n.historyText" select="'Text'"/>
    <xsl:variable name="i18n.historyDetails" select="'Details:'"/>
    <xsl:variable name="i18n.payment" select="'Payment details'"/>
    <xsl:variable name="i18n.contract_information" select="'Contract Information'"/>
    <xsl:variable name="i18n.preceding_invoice_reference" select="'Previous invoices'"/>

    <xsl:include href="xrechnung-html.univ.xsl"/>

</xsl:stylesheet>
