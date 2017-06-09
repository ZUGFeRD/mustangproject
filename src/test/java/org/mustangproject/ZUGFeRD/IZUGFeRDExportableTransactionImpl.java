package org.mustangproject.ZUGFeRD;

import java.util.Date;

public class IZUGFeRDExportableTransactionImpl implements IZUGFeRDExportableTransaction {
    private String number;
    private Date issueDate;
    private String ownOrganisationFullPlaintextInfo;
    private Date dueDate;
    private IZUGFeRDAllowanceCharge[] zFAllowances;
    private IZUGFeRDAllowanceCharge[] zFCharges;
    private IZUGFeRDAllowanceCharge[] zFLogisticsServiceCharges;
    private IZUGFeRDExportableItem[] zFItems;
    private IZUGFeRDExportableContact recipient;
    private String ownBIC;
    private String ownBankName;
    private String ownIBAN;
    private String ownTaxID;
    private String ownVATID;
    private String ownOrganisationName;
    private String ownStreet;
    private String ownZIP;
    private String ownLocation;
    private String ownCountry;
    private Date deliveryDate;
    private String currency;
    private String ownPaymentInfoText;
    private String paymentTermDescription;
    private String referenceNumber;

    @Override
    public String getNumber() {
        return number;
    }

    @Override
    public Date getIssueDate() {
        return issueDate;
    }

    @Override
    public String getOwnOrganisationFullPlaintextInfo() {
        return ownOrganisationFullPlaintextInfo;
    }

    @Override
    public Date getDueDate() {
        return dueDate;
    }

    @Override
    public IZUGFeRDAllowanceCharge[] getZFAllowances() {
        return zFAllowances;
    }

    @Override
    public IZUGFeRDAllowanceCharge[] getZFCharges() {
        return zFCharges;
    }

    @Override
    public IZUGFeRDAllowanceCharge[] getZFLogisticsServiceCharges() {
        return zFLogisticsServiceCharges;
    }

    @Override
    public IZUGFeRDExportableItem[] getZFItems() {
        return zFItems;
    }

    @Override
    public IZUGFeRDExportableContact getRecipient() {
        return recipient;
    }

    @Override
    public String getOwnBIC() {
        return ownBIC;
    }

    @Override
    public String getOwnBankName() {
        return ownBankName;
    }

    @Override
    public String getOwnIBAN() {
        return ownIBAN;
    }

    @Override
    public String getOwnTaxID() {
        return ownTaxID;
    }

    @Override
    public String getOwnVATID() {
        return ownVATID;
    }

    @Override
    public String getOwnOrganisationName() {
        return ownOrganisationName;
    }

    @Override
    public String getOwnStreet() {
        return ownStreet;
    }

    @Override
    public String getOwnZIP() {
        return ownZIP;
    }

    @Override
    public String getOwnLocation() {
        return ownLocation;
    }

    @Override
    public String getOwnCountry() {
        return ownCountry;
    }

    @Override
    public Date getDeliveryDate() {
        return deliveryDate;
    }

    @Override
    public String getCurrency() {
        return currency;
    }

    @Override
    public String getOwnPaymentInfoText() {
        return ownPaymentInfoText;
    }

    @Override
    public String getPaymentTermDescription() {
        return paymentTermDescription;
    }

    @Override
    public String getReferenceNumber() {
        return referenceNumber;
    }

    public IZUGFeRDExportableTransactionImpl setNumber(String number) {
        this.number = number;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setIssueDate(Date issueDate) {
        this.issueDate = issueDate;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setOwnOrganisationFullPlaintextInfo(String ownOrganisationFullPlaintextInfo) {
        this.ownOrganisationFullPlaintextInfo = ownOrganisationFullPlaintextInfo;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setDueDate(Date dueDate) {
        this.dueDate = dueDate;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setZFAllowances(IZUGFeRDAllowanceCharge... zFAllowances) {
        this.zFAllowances = zFAllowances;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setZFCharges(IZUGFeRDAllowanceCharge... zFCharges) {
        this.zFCharges = zFCharges;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setZFLogisticsServiceCharges(IZUGFeRDAllowanceCharge... zFLogisticsServiceCharges) {
        this.zFLogisticsServiceCharges = zFLogisticsServiceCharges;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setZFItems(IZUGFeRDExportableItem... zFItems) {
        this.zFItems = zFItems;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setRecipient(IZUGFeRDExportableContact recipient) {
        this.recipient = recipient;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setOwnBIC(String ownBIC) {
        this.ownBIC = ownBIC;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setOwnBankName(String ownBankName) {
        this.ownBankName = ownBankName;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setOwnIBAN(String ownIBAN) {
        this.ownIBAN = ownIBAN;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setOwnTaxID(String ownTaxID) {
        this.ownTaxID = ownTaxID;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setOwnVATID(String ownVATID) {
        this.ownVATID = ownVATID;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setOwnOrganisationName(String ownOrganisationName) {
        this.ownOrganisationName = ownOrganisationName;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setOwnStreet(String ownStreet) {
        this.ownStreet = ownStreet;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setOwnZIP(String ownZIP) {
        this.ownZIP = ownZIP;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setOwnLocation(String ownLocation) {
        this.ownLocation = ownLocation;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setOwnCountry(String ownCountry) {
        this.ownCountry = ownCountry;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setDeliveryDate(Date deliveryDate) {
        this.deliveryDate = deliveryDate;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setCurrency(String currency) {
        this.currency = currency;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setOwnPaymentInfoText(String ownPaymentInfoText) {
        this.ownPaymentInfoText = ownPaymentInfoText;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setPaymentTermDescription(String paymentTermDescription) {
        this.paymentTermDescription = paymentTermDescription;
        return this;
    }

    public IZUGFeRDExportableTransactionImpl setReferenceNumber(String referenceNumber) {
        this.referenceNumber = referenceNumber;
        return this;
    }
}
