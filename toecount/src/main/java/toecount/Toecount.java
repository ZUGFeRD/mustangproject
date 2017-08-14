package toecount;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.regex.Pattern;

import javax.xml.bind.JAXBException;
import javax.xml.transform.TransformerException;

import org.mustangproject.ZUGFeRD.ZUGFeRDExporter;
import org.mustangproject.ZUGFeRD.ZUGFeRDImporter;

import com.sanityinc.jargs.CmdLineParser;
import com.sanityinc.jargs.CmdLineParser.Option;

public class Toecount {
	// build with: /opt/local/bin/mvn clean compile assembly:single
	private static void printUsage() {
		System.err.println(getUsage());
	}

	private static String getUsage() {
		return "Usage: Toecount [-d,--directory] [-l,--listfromstdin] [-i,--ignorefileextension] | [-c,--combine] | [-e,--extract] | [-u,--upgrade] | [-h,--help]\r\n";
	}

	private static void printHelp() {
		System.out.println("Mustangproject.org's Toecount 0.2.0 \r\n"
				+ "A Apache Public License command line tool for statistics on PDF invoices with\r\n"
				+ "ZUGFeRD Metadata (http://www.zugferd.org)\r\n" + "\r\n" + getUsage() + "Count operations"
				+ "\t--directory= count ZUGFeRD files in directory to be scanned\r\n"
				+ "\t\tIf it is a directory, it will recurse.\r\n"
				+ "\t--listfromstdin=count ZUGFeRD files from a list of linefeed separated files on runtime.\r\n"
				+ "\t\tIt will start once a blank line has been entered.\r\n"
				+ "\t--ignorefileextension=if PDF files are counted check *.* instead of *.pdf files"
				+ "Merge operations"
				+ "\t--combine= combine ZUGFeRD-invoice.xml and invoice.pdf to invoice.zugferd.pdf\r\n"
				+ "\t--extract= extract invoice.zugferd.pdf to ZUGFeRD-invoice.xml\r\n"
				+ "\t--upgrade= upgrafe ZUGFeRD-invoice.pdf to ZUGFeRD-2-invoice.xml\r\n"

		);
	}

	// /opt/local/bin/mvn clean compile assembly:single
	public static void main(String[] args) {
		CmdLineParser parser = new CmdLineParser();
		Option<String> dirnameOption = parser.addStringOption('d', "directory");
		Option<Boolean> filesFromStdInOption = parser.addBooleanOption('l', "listfromstdin");
		Option<Boolean> ignoreFileExtOption = parser.addBooleanOption('i', "ignorefileextension");
		Option<Boolean> combineOption = parser.addBooleanOption('c', "combine");
		Option<Boolean> extractOption = parser.addBooleanOption('e', "extract");
		Option<Boolean> helpOption = parser.addBooleanOption('h', "help");
		Option<Boolean> upgradeOption = parser.addBooleanOption('u', "upgrade");

		if (args.length == 0) {
			printUsage();
			System.exit(2);

		}
		try {
			parser.parse(args);
		} catch (CmdLineParser.OptionException e) {
			System.err.println(e.getMessage());
			printUsage();
			System.exit(2);
		}

		String directoryName = parser.getOptionValue(dirnameOption);

		Boolean filesFromStdIn = parser.getOptionValue(filesFromStdInOption, Boolean.FALSE);

		Boolean combineRequested = parser.getOptionValue(combineOption, Boolean.FALSE);

		Boolean extractRequested = parser.getOptionValue(extractOption, Boolean.FALSE);

		Boolean helpRequested = parser.getOptionValue(helpOption, Boolean.FALSE);

		Boolean upgradeRequested = parser.getOptionValue(upgradeOption, Boolean.FALSE);

		Boolean ignoreFileExt = parser.getOptionValue(ignoreFileExtOption, Boolean.FALSE);

		if (helpRequested) {
			printHelp();
		}

		if (((directoryName!= null) && (directoryName.length() > 0)) || filesFromStdIn.booleanValue()) {

			StatRun sr = new StatRun();
			if (ignoreFileExt) {
				sr.ignoreFileExtension();
			}
			if (directoryName != null) {
				Path startingDir = Paths.get(directoryName);

				if (Files.isRegularFile(startingDir)) {
					String filename = startingDir.toString();
					FileChecker fc = new FileChecker(filename, sr);

					fc.checkForZUGFeRD();
					System.out.print(fc.getOutputLine());

				} else if (Files.isDirectory(startingDir)) {
					FileTraverser pf = new FileTraverser(sr);
					try {
						Files.walkFileTree(startingDir, pf);
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}

				}

			}

			if (filesFromStdIn) {
				BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
				String s;
				try {
					while ((s = in.readLine()) != null && s.length() != 0) {
						FileChecker fc = new FileChecker(s, sr);

						fc.checkForZUGFeRD();
						System.out.print(fc.getOutputLine());

					}
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			}
			System.out.println(sr.getSummaryLine());
		} else if (combineRequested) {
			/*
			 * ZUGFeRDExporter ze= new ZUGFeRDExporterFromA1Factory()
			 * .setProducer("toecount")
			 * .setCreator(System.getProperty("user.name"))
			 * .loadFromPDFA1("invoice.pdf");
			 */
			try {
				ZUGFeRDExporter ze = new ZUGFeRDExporter();
				ze.PDFmakeA3compliant("./invoice.pdf", "Toecount", System.getProperty("user.name"), true);
				ze.setZUGFeRDXMLData(Files.readAllBytes(Paths.get("./ZUGFeRD-invoice.xml")));
				ze.PDFattachZugferdFile(null);
				ze.export("invoice.ZUGFeRD.pdf");
			} catch (IOException e) {
				e.printStackTrace();
			} catch (JAXBException e) {
				e.printStackTrace();
			} catch (TransformerException e) {
				e.printStackTrace();
			}

			System.out.println("Written to invoice.ZUGFeRD.pdf");
		} else if (extractRequested) {
			ZUGFeRDImporter zi = new ZUGFeRDImporter();
			zi.extract("invoice.zugferd.pdf");
			try {
				Files.write(Paths.get("./ZUGFeRD-invoice.xml"), zi.getRawXML());
			} catch (IOException e) {
				e.printStackTrace();
			}
			System.out.println("Written to ZUGFeRD-invoice.xml");

		} else if (upgradeRequested) {	
			try {
				String xml=new String(Files.readAllBytes(Paths.get("./ZUGFeRD-invoice.xml")),StandardCharsets.UTF_8);
				// todo: attributes may also be in single quotes, this one hardcodedly expects double ones
				xml=xml.replaceAll(Pattern.quote("\"urn:ferd:CrossIndustryDocument:invoice:1p0"), "\"urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:13");
				xml=xml.replaceAll(Pattern.quote("urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12"), "urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:20");
				xml=xml.replaceAll(Pattern.quote("urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15"), "urn:un:unece:uncefact:data:standard:UnqualifiedDataType:20");
				xml=xml.replaceAll(Pattern.quote("rsm:CrossIndustryDocument"), "rsm:CrossIndustryInvoice");
				xml=xml.replaceAll(Pattern.quote("rsm:SpecifiedExchangedDocumentContext"), "rsm:CIExchangedDocumentContext");
				xml=xml.replaceAll(Pattern.quote("rsm:HeaderExchangedDocument"), "rsm:CIIHExchangedDocument");
				xml=xml.replaceAll(Pattern.quote("SpecifiedSupplyChainTradeTransaction"), "CIIHSupplyChainTradeTransaction");
				xml=xml.replaceAll(Pattern.quote("ram:GuidelineSpecifiedDocumentContextParameter"), "ram:GuidelineSpecifiedDocumentCIContextParameter");
				xml=xml.replaceAll(Pattern.quote("ram:IncludedNote"), "ram:IncludedCINote");
				xml=xml.replaceAll(Pattern.quote("ram:ApplicableSupplyChainTradeAgreement"), "ram:ApplicableCIIHSupplyChainTradeAgreement");
				xml=xml.replaceAll(Pattern.quote("ram:SellerTradeParty"), "ram:SellerCITradeParty");
				xml=xml.replaceAll(Pattern.quote("ram:BuyerTradeParty"), "ram:BuyerCITradeParty");
				xml=xml.replaceAll(Pattern.quote("ram:ApplicableSupplyChainTradeDelivery"), "ram:ApplicableCIIHSupplyChainTradeDelivery");
				xml=xml.replaceAll(Pattern.quote("ram:ApplicableSupplyChainTradeSettlement"), "ram:ApplicableCIIHSupplyChainTradeSettlement");
				xml=xml.replaceAll(Pattern.quote("ram:IncludedSupplyChainTradeLineItem"), "ram:IncludedCIILSupplyChainTradeLineItem");
				xml=xml.replaceAll(Pattern.quote("ram:AssociatedDocumentLineDocument"), "ram:AssociatedCIILDocumentLineDocument");
				xml=xml.replaceAll(Pattern.quote("ram:SpecifiedSupplyChainTradeDelivery"), "ram:SpecifiedCIILSupplyChainTradeDelivery");
				xml=xml.replaceAll(Pattern.quote("ram:SpecifiedSupplyChainTradeSettlement"), "ram:SpecifiedCIILSupplyChainTradeSettlement");
				xml=xml.replaceAll(Pattern.quote("ram:SpecifiedTradeSettlementMonetarySummation"), "ram:SpecifiedCIILTradeSettlementMonetarySummation");
				xml=xml.replaceAll(Pattern.quote("ram:SpecifiedTradeProduct"), "ram:SpecifiedCITradeProduct");
				xml=xml.replaceAll(Pattern.quote("ram:ActualDeliverySupplyChainEvent"), "ram:ActualDeliveryCISupplyChainEvent");
				xml=xml.replaceAll(Pattern.quote("ram:SpecifiedTradeSettlementPaymentMeans"), "ram:SpecifiedCITradeSettlementPaymentMeans");
				xml=xml.replaceAll(Pattern.quote("ram:PayeePartyCreditorFinancialAccount"), "ram:PayeePartyCICreditorFinancialAccount");
				xml=xml.replaceAll(Pattern.quote("ram:PayeeSpecifiedCreditorFinancialInstitution"), "ram:PayeeSpecifiedCICreditorFinancialInstitution");
				xml=xml.replaceAll(Pattern.quote("ram:ApplicableTradeTax"), "ram:ApplicableCITradeTax");
				xml=xml.replaceAll(Pattern.quote("ram:ApplicablePercent"), "ram:RateApplicablePercent");
				xml=xml.replaceAll(Pattern.quote("ram:PostalTradeAddress"), "ram:PostalCITradeAddress");
				xml=xml.replaceAll(Pattern.quote("ram:SpecifiedTaxRegistration"), "ram:SpecifiedCITaxRegistration");
				xml=xml.replaceAll(Pattern.quote("ram:PostalTradeAddress"), "ram:PostalCITradeAddress");
				xml=xml.replaceAll(Pattern.quote("ram:SpecifiedTradeSettlementMonetarySummation"), "ram:SpecifiedCITradeSettlementMonetarySummation");
				xml=xml.replaceAll(Pattern.quote("ram:SpecifiedTradePaymentTerms"), "ram:SpecifiedCITradePaymentTerms");
				xml=xml.replaceAll(Pattern.quote("ram:SpecifiedSupplyChainTradeAgreement"), "ram:SpecifiedCIILSupplyChainTradeAgreement");
				xml=xml.replaceAll(Pattern.quote("ram:GrossPriceProductTradePrice"), "ram:GrossPriceProductCITradePrice");
				xml=xml.replaceAll(Pattern.quote("ram:NetPriceProductTradePrice"), "ram:NetPriceProductCITradePrice");
		//		xml=xml.replaceAll("\\<ram:TestIndicator.*\\/ram:TestIndicator>", "");
		//remove manually for the time being:		xml=xml.replaceAll("ram:TestIndicator>(.*?)/ram:TestIndicator>", "");
		// one ram:SpecifiedCIILTradeSettlementMonetarySummation will have to be ram:SpecifiedCIIHTradeSettlementMonetarySummation afterwards
				 


//						entfernen 		<ram:TestIndicator><udt:Indicator>true</udt:Indicator></ram:TestIndicator><!-- Im Echtbetrieb muss der TestIndicator entweder vollständig entfallen oder auf false stehen. -->
//						xmlns:rsm="urn:ferd:CrossIndustryDocument:invoice:1p0"				
				
				Files.write(Paths.get("./ZUGFeRD-2-invoice.xml"), xml.getBytes());
			} catch (IOException e) {
				e.printStackTrace();
			}
			System.out.println("Written to ZUGFeRD-2-invoice.xml");

		}
	}
}
