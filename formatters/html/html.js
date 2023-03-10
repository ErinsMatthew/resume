const fs = require( 'fs' );
const json2html = require( 'node-json2html' );

const html = fs.readFileSync( '/Users/mwf/Code/resume/formatters/html/template.html', 'utf8' );

fs.readFile( process.argv[ 2 ], 'utf8', ( err, data ) => {
    if ( err ) {
        console.error( err );

        return;
    }

    console.log( json2html.render( data, { 'html': html } ) );
} );
