const fs = require( 'fs' );
const Handlebars = require( 'handlebars' );
const dayjs = require( 'dayjs' );
const argv = require( 'minimist' )( process.argv.slice( 2 ) );

const GLOBALS = {
    DATE_FORMAT: argv.format || 'MMMM YYYY',
    FILE_ENCODING: argv.encoding || 'utf8',
    LIST_SEPARATOR: argv.separator || ',&nbsp;',
    QUALIFICATION_COLUMNS: argv.qualcols || 3
};

function formatDate( dateString ) {
    return dayjs( dateString ).format( GLOBALS.DATE_FORMAT );
}

Handlebars.registerHelper( 'date', function ( dateString ) {
    return formatDate( dateString );
} );

Handlebars.registerHelper( 'dateRange', function ( fromString, toString ) {
    let range = [];

    range.push( formatDate( fromString ) );
    range.push( '&nbsp;to&nbsp;' );

    if ( toString ) {
        range.push( formatDate( toString ) );
    } else {
        range.push( 'Present' );
    }

    return new Handlebars.SafeString( range.join( '' ) );
} );

Handlebars.registerHelper( 'cleanLink', function ( urlString ) {
    let link = [ '<a href="', urlString, '" target="_new">' ];

    let url = new URL( urlString );

    link.push( url.host, url.pathname, url.search );

    link.push( '</a>' );

    return new Handlebars.SafeString( link.join( '' ) );
} );

Handlebars.registerHelper( 'join', function ( items, options ) {
    return items.map( i => options.fn( i ) ).join( GLOBALS.LIST_SEPARATOR );
} );

Handlebars.registerHelper( 'colbreak', function ( index ) {
    return new Handlebars.SafeString( index % GLOBALS.QUALIFICATION_COLUMNS == ( GLOBALS.QUALIFICATION_COLUMNS - 1 ) ? '</td><td>' : '' );
} );

const template = Handlebars.compile( fs.readFileSync( argv.template, GLOBALS.FILE_ENCODING ) );

fs.readFile( argv.json, GLOBALS.FILE_ENCODING, ( err, data ) => {
    if ( err ) {
        console.error( err );

        return;
    }

    console.log( template( JSON.parse( data ) ) );
} );
