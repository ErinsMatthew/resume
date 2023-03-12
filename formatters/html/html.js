const fs = require( 'fs' );
const Handlebars = require( 'handlebars' );
const dayjs = require( 'dayjs' );

fs.readFile( process.argv[ 2 ], 'utf8', ( err, data ) => {
    if ( err ) {
        console.error( err );

        return;
    }

    const jsonData = JSON.parse( data );

    Handlebars.registerHelper( 'date', function ( dateString ) {
        let dt = dayjs( dateString );

        return dt.format( "MMMM YYYY" );
    } )

    const template = Handlebars.compile( fs.readFileSync( '/Users/mwf/Code/resume/formatters/html/template.html', 'utf8' ) );

    console.log( template( jsonData ) );
} );
