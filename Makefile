CC		= gcc
LD		= gcc
AR		= ar

CFLAGS		= -ggdb -Wall -ansi
LDFLAGS		= -ggdb -lgsl -lgslcblas
ARFLAGS		= rc

LIBADAPT_OBJS	= lms.o nlms.o selms.o sdlms.o sslms.o rls.o bndr.o

ADAPT_OBJS	= adapt.o libadapt.a
ADAPT_BINS	= adapt

MURLS_BINS	= murls
MURLS_OBJS	= murls.o rls2.o

MULMS_BINS	= mulms
MULMS_OBJS	= mulms.o libadapt.a

ADAPTLMS_BINS	= adaptlms
ADAPTLMS_OBJS	= adaptlms.o libadapt.a

ALL_OBJS	= $(ADAPT_OBJS) $(ADAPTLMS_OBJS) $(MULMS_OBJS) ${MURLS_OBJS} \
                  $(LIBADAPT_OBJS)
ALL_BINS	= $(ADAPT_BINS) $(ADAPTLMS_BINS) $(MULMS_BINS) ${MURLS_BINS}

DATA		= data/*.dat results/*.wav results/*.dat

.c.o:
	$(CC) $(CFLAGS) -c $<

adapt: $(ADAPT_OBJS)
	$(LD) $(LDFLAGS) -o $@ $(ADAPT_OBJS)

libadapt.a: $(LIBADAPT_OBJS)
	$(AR) $(ARFLAGS) $@ $(LIBADAPT_OBJS)

adaptlms: $(ADAPTLMS_OBJS)
	$(LD) $(LDFLAGS) -o $@ $(ADAPTLMS_OBJS)

mulms: $(MULMS_OBJS)
	$(LD) $(LDFLAGS) -o $@ $(MULMS_OBJS)

murls: $(MURLS_OBJS)
	$(LD) $(LDFLAGS) -o $@ $(MURLS_OBJS)



run: adapt
	./adapt
	octave -q < analise.m

clean:
	rm -f $(ALL_OBJS) $(ALL_BINS) core
