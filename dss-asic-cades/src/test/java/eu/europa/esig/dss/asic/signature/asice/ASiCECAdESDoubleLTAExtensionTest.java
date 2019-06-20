package eu.europa.esig.dss.asic.signature.asice;

import static org.junit.Assert.assertEquals;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.junit.Test;

import eu.europa.esig.dss.ASiCContainerType;
import eu.europa.esig.dss.DSSDocument;
import eu.europa.esig.dss.InMemoryDocument;
import eu.europa.esig.dss.MimeType;
import eu.europa.esig.dss.SignatureLevel;
import eu.europa.esig.dss.SignatureValue;
import eu.europa.esig.dss.ToBeSigned;
import eu.europa.esig.dss.asic.ASiCWithCAdESSignatureParameters;
import eu.europa.esig.dss.asic.signature.ASiCWithCAdESService;
import eu.europa.esig.dss.signature.PKIFactoryAccess;
import eu.europa.esig.dss.validation.SignedDocumentValidator;
import eu.europa.esig.dss.validation.policy.rules.Indication;
import eu.europa.esig.dss.validation.reports.DetailedReport;
import eu.europa.esig.dss.validation.reports.Reports;
import eu.europa.esig.dss.validation.reports.SimpleReport;
import eu.europa.esig.dss.validation.reports.wrapper.DiagnosticData;
import eu.europa.esig.dss.validation.reports.wrapper.TimestampWrapper;

public class ASiCECAdESDoubleLTAExtensionTest extends PKIFactoryAccess {
	
	@Test
	public void test() throws IOException {
		
		List<DSSDocument> documentToSigns = new ArrayList<DSSDocument>();
		documentToSigns.add(new InMemoryDocument("Hello World !".getBytes(), "test.text", MimeType.TEXT));
		documentToSigns.add(new InMemoryDocument("Bye World !".getBytes(), "test2.text", MimeType.TEXT));

		ASiCWithCAdESSignatureParameters signatureParameters = new ASiCWithCAdESSignatureParameters();
		signatureParameters.bLevel().setSigningDate(new Date());
		signatureParameters.setSigningCertificate(getSigningCert());
		signatureParameters.setCertificateChain(getCertificateChain());
		signatureParameters.setSignatureLevel(SignatureLevel.CAdES_BASELINE_LT);
		signatureParameters.aSiC().setContainerType(ASiCContainerType.ASiC_E);

		ASiCWithCAdESService service = new ASiCWithCAdESService(getCompleteCertificateVerifier());
		service.setTspSource(getGoodTsa());

		ToBeSigned dataToSign = service.getDataToSign(documentToSigns, signatureParameters);
		SignatureValue signatureValue = getToken().sign(dataToSign, signatureParameters.getDigestAlgorithm(), getPrivateKeyEntry());
		DSSDocument signedDocument = service.signDocument(documentToSigns, signatureParameters, signatureValue);

		// signedDocument.save("target/signed.asice");

		service.setTspSource(getGoodTsaCrossCertification());

		ASiCWithCAdESSignatureParameters extendParameters = new ASiCWithCAdESSignatureParameters();
		extendParameters.setSignatureLevel(SignatureLevel.CAdES_BASELINE_LTA);
		extendParameters.aSiC().setContainerType(ASiCContainerType.ASiC_E);
		DSSDocument extendedDocument = service.extendDocument(signedDocument, extendParameters);
		
		DSSDocument doubleLTADoc = service.extendDocument(extendedDocument, extendParameters);
		
		// doubleLTADoc.save("target/doubleLTA.asice");
		
		SignedDocumentValidator validator = SignedDocumentValidator.fromDocument(doubleLTADoc);
		validator.setCertificateVerifier(getOfflineCertificateVerifier());
		Reports reports = validator.validateDocument();
		
		// reports.print();
		
		SimpleReport simpleReport = reports.getSimpleReport();
		assertEquals(Indication.TOTAL_PASSED, simpleReport.getIndication(simpleReport.getFirstSignatureId()));
		
		DetailedReport detailedReport = reports.getDetailedReport();
		List<String> timestampIds = detailedReport.getTimestampIds();
		assertEquals(3, timestampIds.size());
		for (String id : timestampIds) {
			assertEquals(Indication.PASSED, detailedReport.getTimestampValidationIndication(id));
		}
		
		DiagnosticData diagnosticData = reports.getDiagnosticData();
		List<TimestampWrapper> timestampList = diagnosticData.getTimestampList();
		assertEquals(3, timestampList.size());
		
		assertEquals(0, timestampList.get(0).getTimestampedRevocationIds().size());
		assertEquals(2, timestampList.get(1).getTimestampedRevocationIds().size());
		assertEquals(3, timestampList.get(2).getTimestampedRevocationIds().size());
		
	}

	@Override
	protected String getSigningAlias() {
		return RSA_SHA3_USER;
	}

}
