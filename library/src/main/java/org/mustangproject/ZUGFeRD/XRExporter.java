/**
 * *********************************************************************
 * <p>
 * Copyright 2018 Jochen Staerk
 * <p>
 * Use is subject to license terms.
 * <p>
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at http://www.apache.org/licenses/LICENSE-2.0.
 * <p>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * <p>
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * <p>
 * **********************************************************************
 */
package org.mustangproject.ZUGFeRD;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

public class XRExporter implements IExporter  {
	IXMLProvider xmlProvider;
	IExportableTransaction trans;

	public XRExporter() {
	}


	@Override
	public IExporter setTransaction(IExportableTransaction trans) throws IOException {
		this.trans=trans;
		return this;
	}

	@Override
	public void export(String ZUGFeRDfilename) throws IOException {
		export(new FileOutputStream(new File(ZUGFeRDfilename)));

	}

	@Override
	public void export(OutputStream output) throws IOException {
		xmlProvider.generateXML(trans);
		byte[] bytes=xmlProvider.getXML();
		output.write(bytes, 0, bytes.length);
	}
}
