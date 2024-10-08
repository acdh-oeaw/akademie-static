<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:template match="/" name="tabulator_js">
        <xsl:param name="sortConfig"/>
        <xsl:param name="groupConfig"/>
        <link href="https://unpkg.com/tabulator-tables@6.2.1/dist/css/tabulator.min.css" rel="stylesheet"></link>
        <link href="https://unpkg.com/tabulator-tables@6.2.1/dist/css/tabulator_bootstrap5.min.css" rel="stylesheet"></link>
        <script type="text/javascript" src="https://unpkg.com/tabulator-tables@6.2.1/dist/js/tabulator.min.js"></script>
        <script src="tabulator-js/config.js"></script>
        <script>
            Tabulator.extendModule("mutator", "mutators", {
                stringToNum:function(value, data, type, mutatorParams){
                    return parseInt(value);
                },
            });
        </script>
        <script>
            config.initialSort = <xsl:value-of select="$sortConfig"/>
;
        <xsl:if test="$groupConfig = 'true'">
                config.groupBy = "sitzungsrahmen";
                config.groupHeader = function(value, count, data, group){
                    return "Sitzungen der " + value + " (" + count + " Protokolle)";
                };
        </xsl:if>
            var table = new Tabulator("#myTable", config);
            //trigger download of data.csv file
            document.getElementById("download-csv").addEventListener("click", function(){
            table.download("csv", "data.csv");
            });
            
            //trigger download of data.json file
            document.getElementById("download-json").addEventListener("click", function(){
            table.download("json", "data.json");
            });
            
            //trigger download of data.html file
            document.getElementById("download-html").addEventListener("click", function(){
            table.download("html", "data.html", {style:true});
            });
            table.on("rowClick", function(e, row){
            var data = row.getData();
            if (data.signatur != null) {
                var url = data.signatur + ".html";
            }
            else if (data.id != null) {
                var url = data.id + ".html";
            }
            window.location.href = url;
            });
    </script>
</xsl:template>
</xsl:stylesheet>