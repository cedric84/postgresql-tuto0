/**
 * @brief		The application entry point.
 * @file
 */

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <libpq-fe.h>
#include <pg_config.h>	// contains PG_VERSION_NUM

// https://www.postgresql.org/download/linux/debian/
// libpq-dev	libraries and headers for C language frontend development

// https://www.postgresql.org/docs/12/libpq.html
// Client programs that use libpq must include the header file libpq-fe.h and must link with the libpq library.

static void
fct0(const char* host)
{
	//---Check arguments---//
	assert(NULL	!= host);

	//---Check library version---//
	assert(PG_VERSION_NUM	== PQlibVersion());

	//---Connect---//
	PGconn*	conn	= PQsetdbLogin(host, "5432", NULL, NULL, "mydb", "cedric", "password");
	assert(CONNECTION_OK	== PQstatus(conn));

	//---Submit a command---//
	PGresult*	res	= PQexec(conn, "SELECT rolname, rolcreatedb FROM pg_roles;");
	assert(PGRES_TUPLES_OK	== PQresultStatus(res));

	//---Loop over each row---//
	printf("# of rows: %d\n", PQntuples(res));
	printf("# of fields: %d\n", PQnfields(res));
	for (int row_idx = 0; row_idx < PQntuples(res); row_idx++) {
		for (int field_idx = 0; field_idx < PQnfields(res); field_idx++) {
			assert(0	== PQfformat(res, field_idx));	// textual format.
			printf("%s: %s, ", PQfname(res, field_idx), PQgetvalue(res, row_idx, field_idx));
		}
		printf("\n");
	}

	//---Release the result---//
	PQclear(res);

	//---Disconnect---//
	PQfinish(conn);
}

/**
 * @brief		The application entry point.
 * @param		[in]	argc	The number of arguments.
 * @param		[in]	argv	The arguments values.
 * @return		Returns EXIT_SUCCESS on success.
 */
extern int
main(int argc, char* argv[])
{
	printf("%s started\n", __func__);
	assert(2	== argc);
	const char*	host	= argv[1];
	fct0(host);
	printf("%s terminated\n", __func__);
	return EXIT_SUCCESS;
}
