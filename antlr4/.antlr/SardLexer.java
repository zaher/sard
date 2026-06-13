// Generated from Sard.g4 by ANTLR 4.9.2
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
		AND=1, OR=2, NOT=3, MOD=4, TRUE=5, FALSE=6, PREPROCESSOR=7, TILDETILDE=8, 
		TYPEEQ=9, NEQ=10, NNEQ=11, LTE=12, GTE=13, INC=14, DEC=15, PLUS_ASSIGN=16, 
		MINUS_ASSIGN=17, PLUS=18, MINUS=19, STAR=20, SLASH=21, CARET=22, PERCENT=23, 
		AMPERSAND=24, BAR=25, BANG=26, TILDE=27, AT=28, EQ=29, LT=30, GT=31, LPAREN=32, 
		RPAREN=33, LBRACE=34, RBRACE=35, LBRACKET=36, RBRACKET=37, COLON=38, SEMI=39, 
		COMMA=40, DOT=41, CURRENCY_LITERAL=42, COLOR_LITERAL=43, HEX_LITERAL=44, 
		NUMBER_LITERAL=45, INTEGER_LITERAL=46, ESCAPE_SEQ=47, STRING_LITERAL=48, 
		IDENTIFIER=49, LINE_COMMENT=50, BLOCK_COMMENT=51, CURLY_BLOCK_COMMENT=52, 
		WS=53;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"AND", "OR", "NOT", "MOD", "TRUE", "FALSE", "PREPROCESSOR", "TILDETILDE", 
			"TYPEEQ", "NEQ", "NNEQ", "LTE", "GTE", "INC", "DEC", "PLUS_ASSIGN", "MINUS_ASSIGN", 
			"PLUS", "MINUS", "STAR", "SLASH", "CARET", "PERCENT", "AMPERSAND", "BAR", 
			"BANG", "TILDE", "AT", "EQ", "LT", "GT", "LPAREN", "RPAREN", "LBRACE", 
			"RBRACE", "LBRACKET", "RBRACKET", "COLON", "SEMI", "COMMA", "DOT", "CURRENCY_LITERAL", 
			"COLOR_LITERAL", "HEX_LITERAL", "NUMBER_LITERAL", "INTEGER_LITERAL", 
			"ESCAPE_SEQ", "STRING_LITERAL", "IDENTIFIER", "LINE_COMMENT", "BLOCK_COMMENT", 
			"CURLY_BLOCK_COMMENT", "WS"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, "'~~'", "'=='", "'<>'", 
			"'!='", "'<='", "'>='", "'++'", "'--'", "'+='", "'-='", "'+'", "'-'", 
			"'*'", "'/'", "'^'", "'%'", "'&'", "'|'", "'!'", "'~'", "'@'", "'='", 
			"'<'", "'>'", "'('", "')'", "'{'", "'}'", "'['", "']'", "':'", "';'", 
			"','", "'.'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, "AND", "OR", "NOT", "MOD", "TRUE", "FALSE", "PREPROCESSOR", "TILDETILDE", 
			"TYPEEQ", "NEQ", "NNEQ", "LTE", "GTE", "INC", "DEC", "PLUS_ASSIGN", "MINUS_ASSIGN", 
			"PLUS", "MINUS", "STAR", "SLASH", "CARET", "PERCENT", "AMPERSAND", "BAR", 
			"BANG", "TILDE", "AT", "EQ", "LT", "GT", "LPAREN", "RPAREN", "LBRACE", 
			"RBRACE", "LBRACKET", "RBRACKET", "COLON", "SEMI", "COMMA", "DOT", "CURRENCY_LITERAL", 
			"COLOR_LITERAL", "HEX_LITERAL", "NUMBER_LITERAL", "INTEGER_LITERAL", 
			"ESCAPE_SEQ", "STRING_LITERAL", "IDENTIFIER", "LINE_COMMENT", "BLOCK_COMMENT", 
			"CURLY_BLOCK_COMMENT", "WS"
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\67\u0170\b\1\4\2"+
		"\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4"+
		"\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22"+
		"\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31"+
		"\t\31\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t"+
		" \4!\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t"+
		"+\4,\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t\61\4\62\t\62\4\63\t\63\4\64"+
		"\t\64\4\65\t\65\4\66\t\66\3\2\3\2\3\2\3\2\3\3\3\3\3\3\3\4\3\4\3\4\3\4"+
		"\3\5\3\5\3\5\3\5\3\6\3\6\3\6\3\6\3\6\3\7\3\7\3\7\3\7\3\7\3\7\3\b\3\b\3"+
		"\b\3\b\7\b\u008c\n\b\f\b\16\b\u008f\13\b\3\b\3\b\3\b\3\t\3\t\3\t\3\n\3"+
		"\n\3\n\3\13\3\13\3\13\3\f\3\f\3\f\3\r\3\r\3\r\3\16\3\16\3\16\3\17\3\17"+
		"\3\17\3\20\3\20\3\20\3\21\3\21\3\21\3\22\3\22\3\22\3\23\3\23\3\24\3\24"+
		"\3\25\3\25\3\26\3\26\3\27\3\27\3\30\3\30\3\31\3\31\3\32\3\32\3\33\3\33"+
		"\3\34\3\34\3\35\3\35\3\36\3\36\3\37\3\37\3 \3 \3!\3!\3\"\3\"\3#\3#\3$"+
		"\3$\3%\3%\3&\3&\3\'\3\'\3(\3(\3)\3)\3*\3*\3+\3+\6+\u00e4\n+\r+\16+\u00e5"+
		"\3+\3+\3+\5+\u00eb\n+\3+\5+\u00ee\n+\3+\5+\u00f1\n+\3+\5+\u00f4\n+\3+"+
		"\5+\u00f7\n+\5+\u00f9\n+\3,\3,\3,\3,\3,\5,\u0100\n,\3,\5,\u0103\n,\3,"+
		"\5,\u0106\n,\3-\3-\3-\6-\u010b\n-\r-\16-\u010c\3.\6.\u0110\n.\r.\16.\u0111"+
		"\3.\3.\6.\u0116\n.\r.\16.\u0117\3/\6/\u011b\n/\r/\16/\u011c\3\60\3\60"+
		"\3\60\3\61\3\61\3\61\5\61\u0125\n\61\3\61\7\61\u0128\n\61\f\61\16\61\u012b"+
		"\13\61\3\61\3\61\3\61\3\61\5\61\u0131\n\61\3\61\7\61\u0134\n\61\f\61\16"+
		"\61\u0137\13\61\3\61\5\61\u013a\n\61\3\62\3\62\7\62\u013e\n\62\f\62\16"+
		"\62\u0141\13\62\3\63\3\63\3\63\3\63\7\63\u0147\n\63\f\63\16\63\u014a\13"+
		"\63\3\63\3\63\3\64\3\64\3\64\3\64\7\64\u0152\n\64\f\64\16\64\u0155\13"+
		"\64\3\64\3\64\3\64\3\64\3\64\3\65\3\65\3\65\3\65\7\65\u0160\n\65\f\65"+
		"\16\65\u0163\13\65\3\65\3\65\3\65\3\65\3\65\3\66\6\66\u016b\n\66\r\66"+
		"\16\66\u016c\3\66\3\66\5\u008d\u0153\u0161\2\67\3\3\5\4\7\5\t\6\13\7\r"+
		"\b\17\t\21\n\23\13\25\f\27\r\31\16\33\17\35\20\37\21!\22#\23%\24\'\25"+
		")\26+\27-\30/\31\61\32\63\33\65\34\67\359\36;\37= ?!A\"C#E$G%I&K\'M(O"+
		")Q*S+U,W-Y.[/]\60_\61a\62c\63e\64g\65i\66k\67\3\2\30\4\2CCcc\4\2PPpp\4"+
		"\2FFff\4\2QQqq\4\2TTtt\4\2VVvv\4\2OOoo\4\2WWww\4\2GGgg\4\2HHhh\4\2NNn"+
		"n\4\2UUuu\3\2\62;\5\2\62;CHch\4\2ZZzz\7\2\62\62^^ppttvv\5\2\f\f\17\17"+
		"$$\5\2\f\f\17\17))\5\2C\\aac|\6\2\62;C\\aac|\4\2\f\f\17\17\5\2\13\f\17"+
		"\17\"\"\2\u018a\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3"+
		"\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2\2"+
		"\2\27\3\2\2\2\2\31\3\2\2\2\2\33\3\2\2\2\2\35\3\2\2\2\2\37\3\2\2\2\2!\3"+
		"\2\2\2\2#\3\2\2\2\2%\3\2\2\2\2\'\3\2\2\2\2)\3\2\2\2\2+\3\2\2\2\2-\3\2"+
		"\2\2\2/\3\2\2\2\2\61\3\2\2\2\2\63\3\2\2\2\2\65\3\2\2\2\2\67\3\2\2\2\2"+
		"9\3\2\2\2\2;\3\2\2\2\2=\3\2\2\2\2?\3\2\2\2\2A\3\2\2\2\2C\3\2\2\2\2E\3"+
		"\2\2\2\2G\3\2\2\2\2I\3\2\2\2\2K\3\2\2\2\2M\3\2\2\2\2O\3\2\2\2\2Q\3\2\2"+
		"\2\2S\3\2\2\2\2U\3\2\2\2\2W\3\2\2\2\2Y\3\2\2\2\2[\3\2\2\2\2]\3\2\2\2\2"+
		"_\3\2\2\2\2a\3\2\2\2\2c\3\2\2\2\2e\3\2\2\2\2g\3\2\2\2\2i\3\2\2\2\2k\3"+
		"\2\2\2\3m\3\2\2\2\5q\3\2\2\2\7t\3\2\2\2\tx\3\2\2\2\13|\3\2\2\2\r\u0081"+
		"\3\2\2\2\17\u0087\3\2\2\2\21\u0093\3\2\2\2\23\u0096\3\2\2\2\25\u0099\3"+
		"\2\2\2\27\u009c\3\2\2\2\31\u009f\3\2\2\2\33\u00a2\3\2\2\2\35\u00a5\3\2"+
		"\2\2\37\u00a8\3\2\2\2!\u00ab\3\2\2\2#\u00ae\3\2\2\2%\u00b1\3\2\2\2\'\u00b3"+
		"\3\2\2\2)\u00b5\3\2\2\2+\u00b7\3\2\2\2-\u00b9\3\2\2\2/\u00bb\3\2\2\2\61"+
		"\u00bd\3\2\2\2\63\u00bf\3\2\2\2\65\u00c1\3\2\2\2\67\u00c3\3\2\2\29\u00c5"+
		"\3\2\2\2;\u00c7\3\2\2\2=\u00c9\3\2\2\2?\u00cb\3\2\2\2A\u00cd\3\2\2\2C"+
		"\u00cf\3\2\2\2E\u00d1\3\2\2\2G\u00d3\3\2\2\2I\u00d5\3\2\2\2K\u00d7\3\2"+
		"\2\2M\u00d9\3\2\2\2O\u00db\3\2\2\2Q\u00dd\3\2\2\2S\u00df\3\2\2\2U\u00e1"+
		"\3\2\2\2W\u00fa\3\2\2\2Y\u0107\3\2\2\2[\u010f\3\2\2\2]\u011a\3\2\2\2_"+
		"\u011e\3\2\2\2a\u0139\3\2\2\2c\u013b\3\2\2\2e\u0142\3\2\2\2g\u014d\3\2"+
		"\2\2i\u015b\3\2\2\2k\u016a\3\2\2\2mn\t\2\2\2no\t\3\2\2op\t\4\2\2p\4\3"+
		"\2\2\2qr\t\5\2\2rs\t\6\2\2s\6\3\2\2\2tu\t\3\2\2uv\t\5\2\2vw\t\7\2\2w\b"+
		"\3\2\2\2xy\t\b\2\2yz\t\5\2\2z{\t\4\2\2{\n\3\2\2\2|}\t\7\2\2}~\t\6\2\2"+
		"~\177\t\t\2\2\177\u0080\t\n\2\2\u0080\f\3\2\2\2\u0081\u0082\t\13\2\2\u0082"+
		"\u0083\t\2\2\2\u0083\u0084\t\f\2\2\u0084\u0085\t\r\2\2\u0085\u0086\t\n"+
		"\2\2\u0086\16\3\2\2\2\u0087\u0088\7}\2\2\u0088\u0089\7A\2\2\u0089\u008d"+
		"\3\2\2\2\u008a\u008c\13\2\2\2\u008b\u008a\3\2\2\2\u008c\u008f\3\2\2\2"+
		"\u008d\u008e\3\2\2\2\u008d\u008b\3\2\2\2\u008e\u0090\3\2\2\2\u008f\u008d"+
		"\3\2\2\2\u0090\u0091\7A\2\2\u0091\u0092\7\177\2\2\u0092\20\3\2\2\2\u0093"+
		"\u0094\7\u0080\2\2\u0094\u0095\7\u0080\2\2\u0095\22\3\2\2\2\u0096\u0097"+
		"\7?\2\2\u0097\u0098\7?\2\2\u0098\24\3\2\2\2\u0099\u009a\7>\2\2\u009a\u009b"+
		"\7@\2\2\u009b\26\3\2\2\2\u009c\u009d\7#\2\2\u009d\u009e\7?\2\2\u009e\30"+
		"\3\2\2\2\u009f\u00a0\7>\2\2\u00a0\u00a1\7?\2\2\u00a1\32\3\2\2\2\u00a2"+
		"\u00a3\7@\2\2\u00a3\u00a4\7?\2\2\u00a4\34\3\2\2\2\u00a5\u00a6\7-\2\2\u00a6"+
		"\u00a7\7-\2\2\u00a7\36\3\2\2\2\u00a8\u00a9\7/\2\2\u00a9\u00aa\7/\2\2\u00aa"+
		" \3\2\2\2\u00ab\u00ac\7-\2\2\u00ac\u00ad\7?\2\2\u00ad\"\3\2\2\2\u00ae"+
		"\u00af\7/\2\2\u00af\u00b0\7?\2\2\u00b0$\3\2\2\2\u00b1\u00b2\7-\2\2\u00b2"+
		"&\3\2\2\2\u00b3\u00b4\7/\2\2\u00b4(\3\2\2\2\u00b5\u00b6\7,\2\2\u00b6*"+
		"\3\2\2\2\u00b7\u00b8\7\61\2\2\u00b8,\3\2\2\2\u00b9\u00ba\7`\2\2\u00ba"+
		".\3\2\2\2\u00bb\u00bc\7\'\2\2\u00bc\60\3\2\2\2\u00bd\u00be\7(\2\2\u00be"+
		"\62\3\2\2\2\u00bf\u00c0\7~\2\2\u00c0\64\3\2\2\2\u00c1\u00c2\7#\2\2\u00c2"+
		"\66\3\2\2\2\u00c3\u00c4\7\u0080\2\2\u00c48\3\2\2\2\u00c5\u00c6\7B\2\2"+
		"\u00c6:\3\2\2\2\u00c7\u00c8\7?\2\2\u00c8<\3\2\2\2\u00c9\u00ca\7>\2\2\u00ca"+
		">\3\2\2\2\u00cb\u00cc\7@\2\2\u00cc@\3\2\2\2\u00cd\u00ce\7*\2\2\u00ceB"+
		"\3\2\2\2\u00cf\u00d0\7+\2\2\u00d0D\3\2\2\2\u00d1\u00d2\7}\2\2\u00d2F\3"+
		"\2\2\2\u00d3\u00d4\7\177\2\2\u00d4H\3\2\2\2\u00d5\u00d6\7]\2\2\u00d6J"+
		"\3\2\2\2\u00d7\u00d8\7_\2\2\u00d8L\3\2\2\2\u00d9\u00da\7<\2\2\u00daN\3"+
		"\2\2\2\u00db\u00dc\7=\2\2\u00dcP\3\2\2\2\u00dd\u00de\7.\2\2\u00deR\3\2"+
		"\2\2\u00df\u00e0\7\60\2\2\u00e0T\3\2\2\2\u00e1\u00e3\7&\2\2\u00e2\u00e4"+
		"\t\16\2\2\u00e3\u00e2\3\2\2\2\u00e4\u00e5\3\2\2\2\u00e5\u00e3\3\2\2\2"+
		"\u00e5\u00e6\3\2\2\2\u00e6\u00f8\3\2\2\2\u00e7\u00e8\7\60\2\2\u00e8\u00ea"+
		"\t\16\2\2\u00e9\u00eb\t\16\2\2\u00ea\u00e9\3\2\2\2\u00ea\u00eb\3\2\2\2"+
		"\u00eb\u00ed\3\2\2\2\u00ec\u00ee\t\16\2\2\u00ed\u00ec\3\2\2\2\u00ed\u00ee"+
		"\3\2\2\2\u00ee\u00f0\3\2\2\2\u00ef\u00f1\t\16\2\2\u00f0\u00ef\3\2\2\2"+
		"\u00f0\u00f1\3\2\2\2\u00f1\u00f3\3\2\2\2\u00f2\u00f4\t\16\2\2\u00f3\u00f2"+
		"\3\2\2\2\u00f3\u00f4\3\2\2\2\u00f4\u00f6\3\2\2\2\u00f5\u00f7\t\16\2\2"+
		"\u00f6\u00f5\3\2\2\2\u00f6\u00f7\3\2\2\2\u00f7\u00f9\3\2\2\2\u00f8\u00e7"+
		"\3\2\2\2\u00f8\u00f9\3\2\2\2\u00f9V\3\2\2\2\u00fa\u00fb\7%\2\2\u00fb\u00fc"+
		"\t\17\2\2\u00fc\u00fd\t\17\2\2\u00fd\u00ff\t\17\2\2\u00fe\u0100\t\17\2"+
		"\2\u00ff\u00fe\3\2\2\2\u00ff\u0100\3\2\2\2\u0100\u0102\3\2\2\2\u0101\u0103"+
		"\t\17\2\2\u0102\u0101\3\2\2\2\u0102\u0103\3\2\2\2\u0103\u0105\3\2\2\2"+
		"\u0104\u0106\t\17\2\2\u0105\u0104\3\2\2\2\u0105\u0106\3\2\2\2\u0106X\3"+
		"\2\2\2\u0107\u0108\7\62\2\2\u0108\u010a\t\20\2\2\u0109\u010b\t\17\2\2"+
		"\u010a\u0109\3\2\2\2\u010b\u010c\3\2\2\2\u010c\u010a\3\2\2\2\u010c\u010d"+
		"\3\2\2\2\u010dZ\3\2\2\2\u010e\u0110\t\16\2\2\u010f\u010e\3\2\2\2\u0110"+
		"\u0111\3\2\2\2\u0111\u010f\3\2\2\2\u0111\u0112\3\2\2\2\u0112\u0113\3\2"+
		"\2\2\u0113\u0115\7\60\2\2\u0114\u0116\t\16\2\2\u0115\u0114\3\2\2\2\u0116"+
		"\u0117\3\2\2\2\u0117\u0115\3\2\2\2\u0117\u0118\3\2\2\2\u0118\\\3\2\2\2"+
		"\u0119\u011b\t\16\2\2\u011a\u0119\3\2\2\2\u011b\u011c\3\2\2\2\u011c\u011a"+
		"\3\2\2\2\u011c\u011d\3\2\2\2\u011d^\3\2\2\2\u011e\u011f\7^\2\2\u011f\u0120"+
		"\t\21\2\2\u0120`\3\2\2\2\u0121\u0129\7$\2\2\u0122\u0128\n\22\2\2\u0123"+
		"\u0125\7\17\2\2\u0124\u0123\3\2\2\2\u0124\u0125\3\2\2\2\u0125\u0126\3"+
		"\2\2\2\u0126\u0128\7\f\2\2\u0127\u0122\3\2\2\2\u0127\u0124\3\2\2\2\u0128"+
		"\u012b\3\2\2\2\u0129\u0127\3\2\2\2\u0129\u012a\3\2\2\2\u012a\u012c\3\2"+
		"\2\2\u012b\u0129\3\2\2\2\u012c\u013a\7$\2\2\u012d\u0135\7)\2\2\u012e\u0134"+
		"\n\23\2\2\u012f\u0131\7\17\2\2\u0130\u012f\3\2\2\2\u0130\u0131\3\2\2\2"+
		"\u0131\u0132\3\2\2\2\u0132\u0134\7\f\2\2\u0133\u012e\3\2\2\2\u0133\u0130"+
		"\3\2\2\2\u0134\u0137\3\2\2\2\u0135\u0133\3\2\2\2\u0135\u0136\3\2\2\2\u0136"+
		"\u0138\3\2\2\2\u0137\u0135\3\2\2\2\u0138\u013a\7)\2\2\u0139\u0121\3\2"+
		"\2\2\u0139\u012d\3\2\2\2\u013ab\3\2\2\2\u013b\u013f\t\24\2\2\u013c\u013e"+
		"\t\25\2\2\u013d\u013c\3\2\2\2\u013e\u0141\3\2\2\2\u013f\u013d\3\2\2\2"+
		"\u013f\u0140\3\2\2\2\u0140d\3\2\2\2\u0141\u013f\3\2\2\2\u0142\u0143\7"+
		"\61\2\2\u0143\u0144\7\61\2\2\u0144\u0148\3\2\2\2\u0145\u0147\n\26\2\2"+
		"\u0146\u0145\3\2\2\2\u0147\u014a\3\2\2\2\u0148\u0146\3\2\2\2\u0148\u0149"+
		"\3\2\2\2\u0149\u014b\3\2\2\2\u014a\u0148\3\2\2\2\u014b\u014c\b\63\2\2"+
		"\u014cf\3\2\2\2\u014d\u014e\7\61\2\2\u014e\u014f\7,\2\2\u014f\u0153\3"+
		"\2\2\2\u0150\u0152\13\2\2\2\u0151\u0150\3\2\2\2\u0152\u0155\3\2\2\2\u0153"+
		"\u0154\3\2\2\2\u0153\u0151\3\2\2\2\u0154\u0156\3\2\2\2\u0155\u0153\3\2"+
		"\2\2\u0156\u0157\7,\2\2\u0157\u0158\7\61\2\2\u0158\u0159\3\2\2\2\u0159"+
		"\u015a\b\64\2\2\u015ah\3\2\2\2\u015b\u015c\7}\2\2\u015c\u015d\7,\2\2\u015d"+
		"\u0161\3\2\2\2\u015e\u0160\13\2\2\2\u015f\u015e\3\2\2\2\u0160\u0163\3"+
		"\2\2\2\u0161\u0162\3\2\2\2\u0161\u015f\3\2\2\2\u0162\u0164\3\2\2\2\u0163"+
		"\u0161\3\2\2\2\u0164\u0165\7,\2\2\u0165\u0166\7\177\2\2\u0166\u0167\3"+
		"\2\2\2\u0167\u0168\b\65\2\2\u0168j\3\2\2\2\u0169\u016b\t\27\2\2\u016a"+
		"\u0169\3\2\2\2\u016b\u016c\3\2\2\2\u016c\u016a\3\2\2\2\u016c\u016d\3\2"+
		"\2\2\u016d\u016e\3\2\2\2\u016e\u016f\b\66\2\2\u016fl\3\2\2\2\36\2\u008d"+
		"\u00e5\u00ea\u00ed\u00f0\u00f3\u00f6\u00f8\u00ff\u0102\u0105\u010c\u0111"+
		"\u0117\u011c\u0124\u0127\u0129\u0130\u0133\u0135\u0139\u013f\u0148\u0153"+
		"\u0161\u016c\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}