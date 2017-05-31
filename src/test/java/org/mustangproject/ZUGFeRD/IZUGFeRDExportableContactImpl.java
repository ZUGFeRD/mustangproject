package org.mustangproject.ZUGFeRD;

public class IZUGFeRDExportableContactImpl implements IZUGFeRDExportableContact {
    private String name;
    private String zIP;
    private String vATID;
    private String country;
    private String location;
    private String street;

    @Override
    public String getName() {
        return name;
    }

    @Override
    public String getZIP() {
        return zIP;
    }

    @Override
    public String getVATID() {
        return vATID;
    }

    @Override
    public String getCountry() {
        return country;
    }

    @Override
    public String getLocation() {
        return location;
    }

    @Override
    public String getStreet() {
        return street;
    }

    public IZUGFeRDExportableContactImpl setName(String name) {
        this.name = name;
        return this;
    }

    public IZUGFeRDExportableContactImpl setZIP(String zIP) {
        this.zIP = zIP;
        return this;
    }

    public IZUGFeRDExportableContactImpl setVATID(String vATID) {
        this.vATID = vATID;
        return this;
    }

    public IZUGFeRDExportableContactImpl setCountry(String country) {
        this.country = country;
        return this;
    }

    public IZUGFeRDExportableContactImpl setLocation(String location) {
        this.location = location;
        return this;
    }

    public IZUGFeRDExportableContactImpl setStreet(String street) {
        this.street = street;
        return this;
    }
}
