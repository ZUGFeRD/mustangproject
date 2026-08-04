package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.mustangproject.ZUGFeRD.IZUGFeRDPaymentDiscountTerms;
import org.mustangproject.ZUGFeRD.IZUGFeRDPaymentTerms;

import java.util.Date;

/**
 * A simple, mutable implementation of {@link IZUGFeRDPaymentTerms} used by the
 * importer to represent a single {@code <ram:SpecifiedTradePaymentTerms>} block.
 * When an invoice carries multiple payment term blocks (e.g. a Skonto term followed
 * by a net-payment term), the importer populates one instance per block and attaches
 * them via {@link Invoice#addPaymentTerms(IZUGFeRDPaymentTerms)}.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class PaymentTerms implements IZUGFeRDPaymentTerms {

	protected String description;
	protected Date dueDate;
	protected IZUGFeRDPaymentDiscountTerms discountTerms;

	/** Bean constructor. */
	public PaymentTerms() {
	}

	public PaymentTerms(String description, Date dueDate) {
		this.description = description;
		this.dueDate = dueDate;
	}

	public PaymentTerms(String description, Date dueDate, IZUGFeRDPaymentDiscountTerms discountTerms) {
		this.description = description;
		this.dueDate = dueDate;
		this.discountTerms = discountTerms;
	}

	@Override
	public String getDescription() {
		return description;
	}

	public PaymentTerms setDescription(String description) {
		this.description = description;
		return this;
	}

	@Override
	public Date getDueDate() {
		return dueDate;
	}

	public PaymentTerms setDueDate(Date dueDate) {
		this.dueDate = dueDate;
		return this;
	}

	@Override
	public IZUGFeRDPaymentDiscountTerms getDiscountTerms() {
		return discountTerms;
	}

	public PaymentTerms setDiscountTerms(IZUGFeRDPaymentDiscountTerms discountTerms) {
		this.discountTerms = discountTerms;
		return this;
	}
}
