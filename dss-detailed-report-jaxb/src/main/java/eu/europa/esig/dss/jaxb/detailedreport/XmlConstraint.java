//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.7 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2017.09.25 at 07:51:56 AM CEST 
//


package eu.europa.esig.dss.jaxb.detailedreport;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for Constraint complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="Constraint">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="Name" type="{http://dss.esig.europa.eu/validation/detailed-report}Name"/>
 *         &lt;element name="Status" type="{http://dss.esig.europa.eu/validation/detailed-report}Status"/>
 *         &lt;element name="Error" type="{http://dss.esig.europa.eu/validation/detailed-report}Name" minOccurs="0"/>
 *         &lt;element name="Warning" type="{http://dss.esig.europa.eu/validation/detailed-report}Name" minOccurs="0"/>
 *         &lt;element name="Info" type="{http://dss.esig.europa.eu/validation/detailed-report}Name" minOccurs="0"/>
 *         &lt;element name="AdditionalInfo" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *       &lt;/sequence>
 *       &lt;attribute name="Id" type="{http://www.w3.org/2001/XMLSchema}string" />
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "Constraint", propOrder = {
    "name",
    "status",
    "error",
    "warning",
    "info",
    "additionalInfo"
})
public class XmlConstraint {

    @XmlElement(name = "Name", required = true)
    protected XmlName name;
    @XmlElement(name = "Status", required = true)
    protected XmlStatus status;
    @XmlElement(name = "Error")
    protected XmlName error;
    @XmlElement(name = "Warning")
    protected XmlName warning;
    @XmlElement(name = "Info")
    protected XmlName info;
    @XmlElement(name = "AdditionalInfo")
    protected String additionalInfo;
    @XmlAttribute(name = "Id")
    protected String id;

    /**
     * Gets the value of the name property.
     * 
     * @return
     *     possible object is
     *     {@link XmlName }
     *     
     */
    public XmlName getName() {
        return name;
    }

    /**
     * Sets the value of the name property.
     * 
     * @param value
     *     allowed object is
     *     {@link XmlName }
     *     
     */
    public void setName(XmlName value) {
        this.name = value;
    }

    /**
     * Gets the value of the status property.
     * 
     * @return
     *     possible object is
     *     {@link XmlStatus }
     *     
     */
    public XmlStatus getStatus() {
        return status;
    }

    /**
     * Sets the value of the status property.
     * 
     * @param value
     *     allowed object is
     *     {@link XmlStatus }
     *     
     */
    public void setStatus(XmlStatus value) {
        this.status = value;
    }

    /**
     * Gets the value of the error property.
     * 
     * @return
     *     possible object is
     *     {@link XmlName }
     *     
     */
    public XmlName getError() {
        return error;
    }

    /**
     * Sets the value of the error property.
     * 
     * @param value
     *     allowed object is
     *     {@link XmlName }
     *     
     */
    public void setError(XmlName value) {
        this.error = value;
    }

    /**
     * Gets the value of the warning property.
     * 
     * @return
     *     possible object is
     *     {@link XmlName }
     *     
     */
    public XmlName getWarning() {
        return warning;
    }

    /**
     * Sets the value of the warning property.
     * 
     * @param value
     *     allowed object is
     *     {@link XmlName }
     *     
     */
    public void setWarning(XmlName value) {
        this.warning = value;
    }

    /**
     * Gets the value of the info property.
     * 
     * @return
     *     possible object is
     *     {@link XmlName }
     *     
     */
    public XmlName getInfo() {
        return info;
    }

    /**
     * Sets the value of the info property.
     * 
     * @param value
     *     allowed object is
     *     {@link XmlName }
     *     
     */
    public void setInfo(XmlName value) {
        this.info = value;
    }

    /**
     * Gets the value of the additionalInfo property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAdditionalInfo() {
        return additionalInfo;
    }

    /**
     * Sets the value of the additionalInfo property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAdditionalInfo(String value) {
        this.additionalInfo = value;
    }

    /**
     * Gets the value of the id property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getId() {
        return id;
    }

    /**
     * Sets the value of the id property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setId(String value) {
        this.id = value;
    }

}
