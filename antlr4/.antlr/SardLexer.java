// Generated from d:\\lab\\pascal\\sard\\antlr4\\Sard.g4 by ANTLR 4.9.2
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class SardLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.9.2", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		AND=1, OR=2, NOT=3, MOD=4, TRUE=5, FALSE=6, TILDETILDE=7, TYPEEQ=8, NEQ=9, 
		NNEQ=10, LTE=11, GTE=12, INC=13, DEC=14, PLUS_ASSIGN=15, MINUS_ASSIGN=16, 
		PREPROCESSOR=17, PLUS=18, MINUS=19, STAR=20, SLASH=21, CARET=22, PERCENT=23, 
		AMPERSAND=24, BAR=25, BANG=26, TILDE=27, AT=28, EQ=29, LT=30, GT=31, LPAREN=32, 
		RPAREN=33, LBRACE=34, RBRACE=35, LBRACKET=36, RBRACKET=37, COLON=38, SEMI=39, 
		COMMA=40, DOT=41, CURRENCY_LITERAL=42, COLOR_LITERAL=43, HEX_LITERAL=44, 
		NUMBER_LITERAL=45, INTEGER_LITERAL=46, ESCAPE_SEQ=47, STRING_LITERAL=48, 
		IDENTIFIER=49, LINE_COMMENT=50, BLOCK_COMMENT=51, WS=52;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"AND", "OR", "NOT", "MOD", "TRUE", "FALSE", "TILDETILDE", "TYPEEQ", "NEQ", 
			"NNEQ", "LTE", "GTE", "INC", "DEC", "PLUS_ASSIGN", "MINUS_ASSIGN", "PREPROCESSOR", 
			"PLUS", "MINUS", "STAR", "SLASH", "CARET", "PERCENT", "AMPERSAND", "BAR", 
			"BANG", "TILDE", "AT", "EQ", "LT", "GT", "LPAREN", "RPAREN", "LBRACE", 
			"RBRACE", "LBRACKET", "RBRACKET", "COLON", "SEMI", "COMMA", "DOT", "CURRENCY_LITERAL", 
			"COLOR_LITERAL", "HEX_LITERAL", "NUMBER_LITERAL", "INTEGER_LITERAL", 
			"ESCAPE_SEQ", "STRING_LITERAL", "IDENTIFIER", "LINE_COMMENT", "BLOCK_COMMENT", 
			"WS"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'and'", "'or'", "'not'", "'mod'", "'true'", "'false'", "'~~'", 
			"'=='", "'<>'", "'!='", "'<='", "'>='", "'++'", "'--'", "'+='", "'-='", 
			null, "'+'", "'-'", "'*'", "'/'", "'^'", "'%'", "'&'", "'|'", "'!'", 
			"'~'", "'@'", "'='", "'<'", "'>'", "'('", "')'", "'{'", "'}'", "'['", 
			"']'", "':'", "';'", "','", "'.'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, "AND", "OR", "NOT", "MOD", "TRUE", "FALSE", "TILDETILDE", "TYPEEQ", 
			"NEQ", "NNEQ", "LTE", "GTE", "INC", "DEC", "PLUS_ASSIGN", "MINUS_ASSIGN", 
			"PREPROCESSOR", "PLUS", "MINUS", "STAR", "SLASH", "CARET", "PERCENT", 
			"AMPERSAND", "BAR", "BANG", "TILDE", "AT", "EQ", "LT", "GT", "LPAREN", 
			"RPAREN", "LBRACE", "RBRACE", "LBRACKET", "RBRACKET", "COLON", "SEMI", 
			"COMMA", "DOT", "CURRENCY_LITERAL", "COLOR_LITERAL", "HEX_LITERAL", "NUMBER_LITERAL", 
			"INTEGER_LITERAL", "ESCAPE_SEQ", "STRING_LITERAL", "IDENTIFIER", "LINE_COMMENT", 
			"BLOCK_COMMENT", "WS"
		};
	}
	private static final String[] _SYMBOLIC_NAMES = makeSymbolicNames();
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}


	public SardLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "Sard.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getChannelNames() { return channelNames; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\66\u0160\b\1\4\2"+
		"\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4"+
		"\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22"+
		"\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31"+
		"\t\31\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t"+
		" \4!\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t"+
		"+\4,\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t\61\4\62\t\62\4\63\t\63\4\64"+
		"\t\64\4\65\t\65\3\2\3\2\3\2\3\2\3\3\3\3\3\3\3\4\3\4\3\4\3\4\3\5\3\5\3"+
		"\5\3\5\3\6\3\6\3\6\3\6\3\6\3\7\3\7\3\7\3\7\3\7\3\7\3\b\3\b\3\b\3\t\3\t"+
		"\3\t\3\n\3\n\3\n\3\13\3\13\3\13\3\f\3\f\3\f\3\r\3\r\3\r\3\16\3\16\3\16"+
		"\3\17\3\17\3\17\3\20\3\20\3\20\3\21\3\21\3\21\3\22\3\22\3\22\3\22\7\22"+
		"\u00a8\n\22\f\22\16\22\u00ab\13\22\3\22\3\22\3\22\3\23\3\23\3\24\3\24"+
		"\3\25\3\25\3\26\3\26\3\27\3\27\3\30\3\30\3\31\3\31\3\32\3\32\3\33\3\33"+
		"\3\34\3\34\3\35\3\35\3\36\3\36\3\37\3\37\3 \3 \3!\3!\3\"\3\"\3#\3#\3$"+
		"\3$\3%\3%\3&\3&\3\'\3\'\3(\3(\3)\3)\3*\3*\3+\3+\6+\u00e2\n+\r+\16+\u00e3"+
		"\3+\3+\3+\5+\u00e9\n+\3+\5+\u00ec\n+\3+\5+\u00ef\n+\3+\5+\u00f2\n+\3+"+
		"\5+\u00f5\n+\5+\u00f7\n+\3,\3,\3,\3,\3,\5,\u00fe\n,\3,\5,\u0101\n,\3,"+
		"\5,\u0104\n,\3-\3-\3-\6-\u0109\n-\r-\16-\u010a\3.\6.\u010e\n.\r.\16.\u010f"+
		"\3.\3.\6.\u0114\n.\r.\16.\u0115\3/\6/\u0119\n/\r/\16/\u011a\3\60\3\60"+
		"\3\60\3\61\3\61\3\61\5\61\u0123\n\61\3\61\7\61\u0126\n\61\f\61\16\61\u0129"+
		"\13\61\3\61\3\61\3\61\3\61\5\61\u012f\n\61\3\61\7\61\u0132\n\61\f\61\16"+
		"\61\u0135\13\61\3\61\5\61\u0138\n\61\3\62\3\62\7\62\u013c\n\62\f\62\16"+
		"\62\u013f\13\62\3\63\3\63\3\63\3\63\7\63\u0145\n\63\f\63\16\63\u0148\13"+
		"\63\3\63\3\63\3\64\3\64\3\64\3\64\7\64\u0150\n\64\f\64\16\64\u0153\13"+
		"\64\3\64\3\64\3\64\3\64\3\64\3\65\6\65\u015b\n\65\r\65\16\65\u015c\3\65"+
		"\3\65\4\u00a9\u0151\2\66\3\3\5\4\7\5\t\6\13\7\r\b\17\t\21\n\23\13\25\f"+
		"\27\r\31\16\33\17\35\20\37\21!\22#\23%\24\'\25)\26+\27-\30/\31\61\32\63"+
		"\33\65\34\67\359\36;\37= ?!A\"C#E$G%I&K\'M(O)Q*S+U,W-Y.[/]\60_\61a\62"+
		"c\63e\64g\65i\66\3\2\f\3\2\62;\5\2\62;CHch\4\2ZZzz\7\2\62\62^^ppttvv\5"+
		"\2\f\f\17\17$$\5\2\f\f\17\17))\5\2C\\aac|\6\2\62;C\\aac|\4\2\f\f\17\17"+
		"\5\2\13\f\17\17\"\"\2\u0179\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3"+
		"\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2"+
		"\2\25\3\2\2\2\2\27\3\2\2\2\2\31\3\2\2\2\2\33\3\2\2\2\2\35\3\2\2\2\2\37"+
		"\3\2\2\2\2!\3\2\2\2\2#\3\2\2\2\2%\3\2\2\2\2\'\3\2\2\2\2)\3\2\2\2\2+\3"+
		"\2\2\2\2-\3\2\2\2\2/\3\2\2\2\2\61\3\2\2\2\2\63\3\2\2\2\2\65\3\2\2\2\2"+
		"\67\3\2\2\2\29\3\2\2\2\2;\3\2\2\2\2=\3\2\2\2\2?\3\2\2\2\2A\3\2\2\2\2C"+
		"\3\2\2\2\2E\3\2\2\2\2G\3\2\2\2\2I\3\2\2\2\2K\3\2\2\2\2M\3\2\2\2\2O\3\2"+
		"\2\2\2Q\3\2\2\2\2S\3\2\2\2\2U\3\2\2\2\2W\3\2\2\2\2Y\3\2\2\2\2[\3\2\2\2"+
		"\2]\3\2\2\2\2_\3\2\2\2\2a\3\2\2\2\2c\3\2\2\2\2e\3\2\2\2\2g\3\2\2\2\2i"+
		"\3\2\2\2\3k\3\2\2\2\5o\3\2\2\2\7r\3\2\2\2\tv\3\2\2\2\13z\3\2\2\2\r\177"+
		"\3\2\2\2\17\u0085\3\2\2\2\21\u0088\3\2\2\2\23\u008b\3\2\2\2\25\u008e\3"+
		"\2\2\2\27\u0091\3\2\2\2\31\u0094\3\2\2\2\33\u0097\3\2\2\2\35\u009a\3\2"+
		"\2\2\37\u009d\3\2\2\2!\u00a0\3\2\2\2#\u00a3\3\2\2\2%\u00af\3\2\2\2\'\u00b1"+
		"\3\2\2\2)\u00b3\3\2\2\2+\u00b5\3\2\2\2-\u00b7\3\2\2\2/\u00b9\3\2\2\2\61"+
		"\u00bb\3\2\2\2\63\u00bd\3\2\2\2\65\u00bf\3\2\2\2\67\u00c1\3\2\2\29\u00c3"+
		"\3\2\2\2;\u00c5\3\2\2\2=\u00c7\3\2\2\2?\u00c9\3\2\2\2A\u00cb\3\2\2\2C"+
		"\u00cd\3\2\2\2E\u00cf\3\2\2\2G\u00d1\3\2\2\2I\u00d3\3\2\2\2K\u00d5\3\2"+
		"\2\2M\u00d7\3\2\2\2O\u00d9\3\2\2\2Q\u00db\3\2\2\2S\u00dd\3\2\2\2U\u00df"+
		"\3\2\2\2W\u00f8\3\2\2\2Y\u0105\3\2\2\2[\u010d\3\2\2\2]\u0118\3\2\2\2_"+
		"\u011c\3\2\2\2a\u0137\3\2\2\2c\u0139\3\2\2\2e\u0140\3\2\2\2g\u014b\3\2"+
		"\2\2i\u015a\3\2\2\2kl\7c\2\2lm\7p\2\2mn\7f\2\2n\4\3\2\2\2op\7q\2\2pq\7"+
		"t\2\2q\6\3\2\2\2rs\7p\2\2st\7q\2\2tu\7v\2\2u\b\3\2\2\2vw\7o\2\2wx\7q\2"+
		"\2xy\7f\2\2y\n\3\2\2\2z{\7v\2\2{|\7t\2\2|}\7w\2\2}~\7g\2\2~\f\3\2\2\2"+
		"\177\u0080\7h\2\2\u0080\u0081\7c\2\2\u0081\u0082\7n\2\2\u0082\u0083\7"+
		"u\2\2\u0083\u0084\7g\2\2\u0084\16\3\2\2\2\u0085\u0086\7\u0080\2\2\u0086"+
		"\u0087\7\u0080\2\2\u0087\20\3\2\2\2\u0088\u0089\7?\2\2\u0089\u008a\7?"+
		"\2\2\u008a\22\3\2\2\2\u008b\u008c\7>\2\2\u008c\u008d\7@\2\2\u008d\24\3"+
		"\2\2\2\u008e\u008f\7#\2\2\u008f\u0090\7?\2\2\u0090\26\3\2\2\2\u0091\u0092"+
		"\7>\2\2\u0092\u0093\7?\2\2\u0093\30\3\2\2\2\u0094\u0095\7@\2\2\u0095\u0096"+
		"\7?\2\2\u0096\32\3\2\2\2\u0097\u0098\7-\2\2\u0098\u0099\7-\2\2\u0099\34"+
		"\3\2\2\2\u009a\u009b\7/\2\2\u009b\u009c\7/\2\2\u009c\36\3\2\2\2\u009d"+
		"\u009e\7-\2\2\u009e\u009f\7?\2\2\u009f \3\2\2\2\u00a0\u00a1\7/\2\2\u00a1"+
		"\u00a2\7?\2\2\u00a2\"\3\2\2\2\u00a3\u00a4\7}\2\2\u00a4\u00a5\7A\2\2\u00a5"+
		"\u00a9\3\2\2\2\u00a6\u00a8\13\2\2\2\u00a7\u00a6\3\2\2\2\u00a8\u00ab\3"+
		"\2\2\2\u00a9\u00aa\3\2\2\2\u00a9\u00a7\3\2\2\2\u00aa\u00ac\3\2\2\2\u00ab"+
		"\u00a9\3\2\2\2\u00ac\u00ad\7A\2\2\u00ad\u00ae\7\177\2\2\u00ae$\3\2\2\2"+
		"\u00af\u00b0\7-\2\2\u00b0&\3\2\2\2\u00b1\u00b2\7/\2\2\u00b2(\3\2\2\2\u00b3"+
		"\u00b4\7,\2\2\u00b4*\3\2\2\2\u00b5\u00b6\7\61\2\2\u00b6,\3\2\2\2\u00b7"+
		"\u00b8\7`\2\2\u00b8.\3\2\2\2\u00b9\u00ba\7\'\2\2\u00ba\60\3\2\2\2\u00bb"+
		"\u00bc\7(\2\2\u00bc\62\3\2\2\2\u00bd\u00be\7~\2\2\u00be\64\3\2\2\2\u00bf"+
		"\u00c0\7#\2\2\u00c0\66\3\2\2\2\u00c1\u00c2\7\u0080\2\2\u00c28\3\2\2\2"+
		"\u00c3\u00c4\7B\2\2\u00c4:\3\2\2\2\u00c5\u00c6\7?\2\2\u00c6<\3\2\2\2\u00c7"+
		"\u00c8\7>\2\2\u00c8>\3\2\2\2\u00c9\u00ca\7@\2\2\u00ca@\3\2\2\2\u00cb\u00cc"+
		"\7*\2\2\u00ccB\3\2\2\2\u00cd\u00ce\7+\2\2\u00ceD\3\2\2\2\u00cf\u00d0\7"+
		"}\2\2\u00d0F\3\2\2\2\u00d1\u00d2\7\177\2\2\u00d2H\3\2\2\2\u00d3\u00d4"+
		"\7]\2\2\u00d4J\3\2\2\2\u00d5\u00d6\7_\2\2\u00d6L\3\2\2\2\u00d7\u00d8\7"+
		"<\2\2\u00d8N\3\2\2\2\u00d9\u00da\7=\2\2\u00daP\3\2\2\2\u00db\u00dc\7."+
		"\2\2\u00dcR\3\2\2\2\u00dd\u00de\7\60\2\2\u00deT\3\2\2\2\u00df\u00e1\7"+
		"&\2\2\u00e0\u00e2\t\2\2\2\u00e1\u00e0\3\2\2\2\u00e2\u00e3\3\2\2\2\u00e3"+
		"\u00e1\3\2\2\2\u00e3\u00e4\3\2\2\2\u00e4\u00f6\3\2\2\2\u00e5\u00e6\7\60"+
		"\2\2\u00e6\u00e8\t\2\2\2\u00e7\u00e9\t\2\2\2\u00e8\u00e7\3\2\2\2\u00e8"+
		"\u00e9\3\2\2\2\u00e9\u00eb\3\2\2\2\u00ea\u00ec\t\2\2\2\u00eb\u00ea\3\2"+
		"\2\2\u00eb\u00ec\3\2\2\2\u00ec\u00ee\3\2\2\2\u00ed\u00ef\t\2\2\2\u00ee"+
		"\u00ed\3\2\2\2\u00ee\u00ef\3\2\2\2\u00ef\u00f1\3\2\2\2\u00f0\u00f2\t\2"+
		"\2\2\u00f1\u00f0\3\2\2\2\u00f1\u00f2\3\2\2\2\u00f2\u00f4\3\2\2\2\u00f3"+
		"\u00f5\t\2\2\2\u00f4\u00f3\3\2\2\2\u00f4\u00f5\3\2\2\2\u00f5\u00f7\3\2"+
		"\2\2\u00f6\u00e5\3\2\2\2\u00f6\u00f7\3\2\2\2\u00f7V\3\2\2\2\u00f8\u00f9"+
		"\7%\2\2\u00f9\u00fa\t\3\2\2\u00fa\u00fb\t\3\2\2\u00fb\u00fd\t\3\2\2\u00fc"+
		"\u00fe\t\3\2\2\u00fd\u00fc\3\2\2\2\u00fd\u00fe\3\2\2\2\u00fe\u0100\3\2"+
		"\2\2\u00ff\u0101\t\3\2\2\u0100\u00ff\3\2\2\2\u0100\u0101\3\2\2\2\u0101"+
		"\u0103\3\2\2\2\u0102\u0104\t\3\2\2\u0103\u0102\3\2\2\2\u0103\u0104\3\2"+
		"\2\2\u0104X\3\2\2\2\u0105\u0106\7\62\2\2\u0106\u0108\t\4\2\2\u0107\u0109"+
		"\t\3\2\2\u0108\u0107\3\2\2\2\u0109\u010a\3\2\2\2\u010a\u0108\3\2\2\2\u010a"+
		"\u010b\3\2\2\2\u010bZ\3\2\2\2\u010c\u010e\t\2\2\2\u010d\u010c\3\2\2\2"+
		"\u010e\u010f\3\2\2\2\u010f\u010d\3\2\2\2\u010f\u0110\3\2\2\2\u0110\u0111"+
		"\3\2\2\2\u0111\u0113\7\60\2\2\u0112\u0114\t\2\2\2\u0113\u0112\3\2\2\2"+
		"\u0114\u0115\3\2\2\2\u0115\u0113\3\2\2\2\u0115\u0116\3\2\2\2\u0116\\\3"+
		"\2\2\2\u0117\u0119\t\2\2\2\u0118\u0117\3\2\2\2\u0119\u011a\3\2\2\2\u011a"+
		"\u0118\3\2\2\2\u011a\u011b\3\2\2\2\u011b^\3\2\2\2\u011c\u011d\7^\2\2\u011d"+
		"\u011e\t\5\2\2\u011e`\3\2\2\2\u011f\u0127\7$\2\2\u0120\u0126\n\6\2\2\u0121"+
		"\u0123\7\17\2\2\u0122\u0121\3\2\2\2\u0122\u0123\3\2\2\2\u0123\u0124\3"+
		"\2\2\2\u0124\u0126\7\f\2\2\u0125\u0120\3\2\2\2\u0125\u0122\3\2\2\2\u0126"+
		"\u0129\3\2\2\2\u0127\u0125\3\2\2\2\u0127\u0128\3\2\2\2\u0128\u012a\3\2"+
		"\2\2\u0129\u0127\3\2\2\2\u012a\u0138\7$\2\2\u012b\u0133\7)\2\2\u012c\u0132"+
		"\n\7\2\2\u012d\u012f\7\17\2\2\u012e\u012d\3\2\2\2\u012e\u012f\3\2\2\2"+
		"\u012f\u0130\3\2\2\2\u0130\u0132\7\f\2\2\u0131\u012c\3\2\2\2\u0131\u012e"+
		"\3\2\2\2\u0132\u0135\3\2\2\2\u0133\u0131\3\2\2\2\u0133\u0134\3\2\2\2\u0134"+
		"\u0136\3\2\2\2\u0135\u0133\3\2\2\2\u0136\u0138\7)\2\2\u0137\u011f\3\2"+
		"\2\2\u0137\u012b\3\2\2\2\u0138b\3\2\2\2\u0139\u013d\t\b\2\2\u013a\u013c"+
		"\t\t\2\2\u013b\u013a\3\2\2\2\u013c\u013f\3\2\2\2\u013d\u013b\3\2\2\2\u013d"+
		"\u013e\3\2\2\2\u013ed\3\2\2\2\u013f\u013d\3\2\2\2\u0140\u0141\7\61\2\2"+
		"\u0141\u0142\7\61\2\2\u0142\u0146\3\2\2\2\u0143\u0145\n\n\2\2\u0144\u0143"+
		"\3\2\2\2\u0145\u0148\3\2\2\2\u0146\u0144\3\2\2\2\u0146\u0147\3\2\2\2\u0147"+
		"\u0149\3\2\2\2\u0148\u0146\3\2\2\2\u0149\u014a\b\63\2\2\u014af\3\2\2\2"+
		"\u014b\u014c\7\61\2\2\u014c\u014d\7,\2\2\u014d\u0151\3\2\2\2\u014e\u0150"+
		"\13\2\2\2\u014f\u014e\3\2\2\2\u0150\u0153\3\2\2\2\u0151\u0152\3\2\2\2"+
		"\u0151\u014f\3\2\2\2\u0152\u0154\3\2\2\2\u0153\u0151\3\2\2\2\u0154\u0155"+
		"\7,\2\2\u0155\u0156\7\61\2\2\u0156\u0157\3\2\2\2\u0157\u0158\b\64\2\2"+
		"\u0158h\3\2\2\2\u0159\u015b\t\13\2\2\u015a\u0159\3\2\2\2\u015b\u015c\3"+
		"\2\2\2\u015c\u015a\3\2\2\2\u015c\u015d\3\2\2\2\u015d\u015e\3\2\2\2\u015e"+
		"\u015f\b\65\2\2\u015fj\3\2\2\2\35\2\u00a9\u00e3\u00e8\u00eb\u00ee\u00f1"+
		"\u00f4\u00f6\u00fd\u0100\u0103\u010a\u010f\u0115\u011a\u0122\u0125\u0127"+
		"\u012e\u0131\u0133\u0137\u013d\u0146\u0151\u015c\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}