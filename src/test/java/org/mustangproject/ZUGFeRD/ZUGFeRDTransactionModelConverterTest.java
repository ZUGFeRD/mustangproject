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

import java.math.BigDecimal;
import java.util.Date;
import java.util.GregorianCalendar;
import javax.xml.bind.JAXBElement;
import org.junit.Test;
import org.mustangproject.ZUGFeRD.model.CrossIndustryDocumentType;

public class ZUGFeRDTransactionModelConverterTest {
    @Test
    public void convertToModel_convertsMinimalTransactionToValidXml() throws Exception {
        // setup
        IZUGFeRDExportableTransaction transaction = new IZUGFeRDExportableTransactionImpl()
            .setIssueDate(createDate(2000, 1, 1))
            .setDeliveryDate(createDate(2000, 1, 2))
            .setDueDate(createDate(2000, 1, 3))
            .setNumber("num")
            .setRecipient(new IZUGFeRDExportableContactImpl()
                .setName("recipient name")
                .setStreet("recipient street")
                .setLocation("recipient city")
                .setCountry("recipient country")
            )
            .setOwnOrganisationName("own org")
            .setOwnStreet("own street")
            .setOwnCountry("own country")
            .setOwnLocation("own city")
            .setOwnBankName("own bank")
            .setZFItems(
                new IZUGFeRDExportableItemImpl()
                    .setProduct(new IZUGFeRDExportableProductImpl()
                        .setVatPercent(new BigDecimal("1.19"))
                        .setName("product name")
                        .setDescription("product description")
                        .setUnit("product unit")
                    )
                    .setQuantity(BigDecimal.ONE)
                    .setPrice(BigDecimal.TEN)
            );

        // execution
        final JAXBElement<CrossIndustryDocumentType> actual =
            new ZUGFeRDTransactionModelConverter(transaction).convertToModel();

        // evaluation
        ZUGFeRDXMLAssert.assertValidZugferd(actual);
    }

    private static Date createDate(int year, int month, int day) {
        final GregorianCalendar calendar = new GregorianCalendar();
        calendar.set(year, month-1, day);
        return calendar.getTime();
    }
}
