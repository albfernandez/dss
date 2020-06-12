package eu.europa.esig.dss.jades;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.jose4j.jws.EcdsaUsingShaAlgorithm;
import org.junit.jupiter.api.Test;

import eu.europa.esig.dss.enumerations.EncryptionAlgorithm;
import eu.europa.esig.dss.spi.DSSASN1Utils;
import eu.europa.esig.dss.utils.Utils;

public class JAdESUtilsTest {
	
	@Test
	public void isUrlSafePayloadTest() {
		assertTrue(JAdESUtils.isUrlSafePayload(""));
		assertTrue(JAdESUtils.isUrlSafePayload("ew0KICAgICJ0aXRsZSI6ICJIZWxsbyBXb3JsZCEiDQp9"));
		assertTrue(JAdESUtils.isUrlSafePayload("ew0KICAgICJ0aXRsZSI6ICJIZWxsbyBXb3JsZCEiDQp9???!!!"));
		assertTrue(JAdESUtils.isUrlSafePayload("ew0KICAgICJ0aXRsZSI6ICJIZWxsb yBXb3JsZCEiDQp9"));
		assertFalse(JAdESUtils.isUrlSafePayload("ew0KICAgICJ0aXRsZSI6ICJIZWxsb.yBXb3JsZCEiDQp9"));
		assertFalse(JAdESUtils.isUrlSafePayload("ew0KICAgICJ0aXRsZSI6ICJIZWxsb\nyBXb3JsZCEiDQp9"));
		assertFalse(JAdESUtils.isUrlSafePayload("ew0KICAgICJ0aXRsZSI6ICJIZWxsb\ryBXb3JsZCEiDQp9"));
		assertFalse(JAdESUtils.isUrlSafePayload("."));
		assertFalse(JAdESUtils.isUrlSafePayload("..."));
	}
	
	@Test
	public void fromAsn1ToRSTest() throws Exception {
		assertSignatureValid(
				"2B9099C9885DDB5BFDA2E9634905B9A63E7E3A6EC87BDC0A89014716B23F00B0AD787FC8D0DCF28F007E7DEC097F30DA892BE2AC61D90997DCDF05740E4D5B0C");
		assertSignatureValid(
				"947b79069e6a1e3316ec15d696649a4b67c6c188df9bc05458f3b0b94907f3fb52522d4cae24a75735969cff556b1476a5ccbe37ca65a928782c14f299f3b2d3");
		assertSignatureValid(
				"28a1583e58e93a661322f776618d83b023bdc52b2e909cf9d53030b9260ed667b588fd39eeee5b1b55523a7e71cb4187d8b1bbf56c1581fc845863157d279cf5");
		assertSignatureValid(
				"dd8fc5414eda2920d347f3d3f9f604fcf09392a8ce3807f6f87d006cf8ed1959075af8abbb030e6990da52fe49c93486a4b98bb2e18e0f84095175eddabfbb96");
		assertSignatureValid(
				"1daf408ead014bba9f243849ece308b31f898e1ce97b54a78b3c15eb103fa8a1c87bdd97fdfc4cb56a7e1e5650dee2ebfff0b56d5a2ca0338e6ed59689e27ae1323f32b0f93b41987a816c93c00462c68c609692084dbced7308a8a66f0365ee5b7b272273e8abd4ddd4a49d2fd67964bc8c757114791446b9716f3b7f551608");
		assertSignatureValid(
				"0d2fc9f18d816e9054af943c392dd46f09da71521de9bd98d765e170f12eb086d3d0f9754105001ed2e703d7290ac967642bc70bdd7a96b5c2b8e3d4b503b80e");
		assertSignatureValid(
				"065a15bd4fec67a2a302d9d3ec679cb8f298f9d6a1d855d3dbf39b3f2fa7ea461e437d9542c4a9527afe5e78c1412937f0dbb05a78380cfb2e1bf6eff944581a");
		assertSignatureValid(
				"f322898717aada9b027855848fa6ec5c4bf84d67a70f0ecbafea9dc90fc1d4f0901325766b199bdcfce1f99a54f0b72e71d740b355fff84a5873fd36c439236e");
		assertSignatureValid(
				"B003267151210F7D8D1A747EEC73A0185CC0E848BF885A9DDE061AB5FB19FB3B6249F8B7B84432738EE80DDAB9654DEA5C4DAB2EC34A5EC8DB17E3DFBF577521");
		assertSignatureValid(
				"C511529B789F64466FE1D524AF9279BEED2F12429798FE0B920F9784A6EBB6400081949A7EE84803E823263CD528F5CE503593F00010191D382B092338AF2E96");
	}

	private void assertSignatureValid(String string) throws Exception {
		byte[] signatureValueConcatenated = Utils.fromHex(string);
		byte[] derEncoded = EcdsaUsingShaAlgorithm.convertConcatenatedToDer(signatureValueConcatenated);
		
		byte[] joseConverted = EcdsaUsingShaAlgorithm.convertDerToConcatenated(derEncoded, 0);
		byte[] asn1Converted = DSSASN1Utils.fromAsn1toSignatureValue(EncryptionAlgorithm.ECDSA, derEncoded);
		assertArrayEquals(joseConverted, asn1Converted);
	}

}
