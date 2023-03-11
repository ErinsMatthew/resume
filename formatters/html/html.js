const fs = require( 'fs' );
const Handlebars = require( 'handlebars' );

fs.readFile( process.argv[ 2 ], 'utf8', ( err, data ) => {
    if ( err ) {
        console.error( err );

        return;
    }

    const jsonData = JSON.parse( data );

    const template = Handlebars.compile( fs.readFileSync( '/Users/mwf/Code/resume/formatters/html/template.html', 'utf8' ) );

    console.log( template( jsonData ) );
} );
