/** **********************************************************************
 *
 * Copyright 2018 Jochen Staerk
 *
 * Use is subject to license terms.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at http://www.apache.org/licenses/LICENSE-2.0.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 *********************************************************************** */
package org.mustangproject.ZUGFeRD;
/**
 * Mustangproject's ZUGFeRD implementation
 * Neccessary interface for ZUGFeRD exporter
 * Licensed under the APLv2
 * @date 2014-05-10
 * @version 1.2.0
 * @author jstaerk
 * */

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import org.mustangproject.IncludedNote;
import org.mustangproject.Item;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

@JsonDeserialize(as = Item.class)
public interface IZUGFeRDExportableItem extends IAbsoluteValueProvider{
	IZUGFeRDExportableProduct getProduct();

	/**
	 * item level discounts
	 * @return array of the discounts on a single item
	 */
	default IZUGFeRDAllowanceCharge[] getItemAllowances() {
		return null;
	}

	/**
	 * item level price additions
	 * @return array of the additional charges on the item
	 */
	default IZUGFeRDAllowanceCharge[] getItemCharges() {
		return null;
	}


	/***
	 * BT 132 (issue https://github.com/ZUGFeRD/mustangproject/issues/247)
	 * @return the line ID of the order (BT-132)
	 */
	default String getBuyerOrderReferencedDocumentLineID() {
		return null;
	}


	/**
	 * The price of one item excl. taxes
	 *
	 * @return The price of one item excl. taxes
	 */
	BigDecimal getPrice();

	@Override
	default BigDecimal getValue() {
		return getPrice();
	}
	/**
	 * how many get billed
	 *
	 * @return the quantity of the item
	 */
	BigDecimal getQuantity();

	/**
	 * how many items units per price
	 * 
	 * @return item units per price
	 */
	default BigDecimal getBasisQuantity() {
		return BigDecimal.ONE.setScale(4);
	}

	/***
	 * the ID of an additionally referenced document for this item
	 * @deprecated use {@link #getAdditionalReferences()} instead.
	 * @return the id as string
	 */
	@Deprecated
	default String getAdditionalReferencedDocumentID() {
		return null;
	}

	/***
	 * allows to specify multiple references (billing information)
	 * @return the referenced documents
	 */
	default IReferencedDocument[] getAdditionalReferences() {
		return null;
	}


	/***
	 * allows to specify multiple(!) referenced documents along with e.g. their typecodes
	 * @return the referenced documents
	 */
	default IReferencedDocument[] getReferencedDocuments() {
		return null;
	}
	/***
	 * descriptive texts
	 * @return an array of strings of item specific "includedNotes", text values
	 */
	default String[] getNotes() {
		return null;
	}



	/***
	 * specifies the item level delivery period (there is also one on document level),
	 * this will be included in a BillingSpecifiedPeriod element
	 * @return the beginning of the delivery period
	 */
	default Date getDetailedDeliveryPeriodFrom() {
		return null;
	}

	/***
	 * specifies the item level delivery period (there is also one on document level),
	 * this will be included in a BillingSpecifiedPeriod element
	 * @return the end of the delivery period
	 */
	default Date getDetailedDeliveryPeriodTo() {
		return null;
	}
	
	/***
	 * specify allowances amount for the line item total
	 *
	 * @return the sum of allowances for this item
	 */
	default IZUGFeRDAllowanceCharge[] getItemTotalAllowances() {
		return null;
	}

	/***
	 *
	 * @return the line ID
	 */
	default String getId()  {
		return null;
	}

	/**
	 * A grouping of business terms to indicate accounting-relevant free texts including a qualification of these.
	 *
	 * The information are written to the same xml nodes like {@link #getNotes()} but with explicit subjectCode.
	 * @return list of the notes
	 */
	default List<IncludedNote> getNotesWithSubjectCode() {
		return null;
	}
}
