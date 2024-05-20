use serde::{Deserialize, Serialize};

mod error;

pub use error::YamlSchemaError;

#[derive(Debug, Serialize, Deserialize, PartialEq)]
#[serde(untagged)]
pub enum YamlSchema {
    AnyOf {
        #[serde(rename = "anyOf")]
        any_of: Vec<Literal>,
    },
    AllOf {
        #[serde(rename = "allOf")]
        all_of: Vec<Literal>,
    },
}

#[derive(Debug, Serialize, Deserialize, PartialEq)]
#[serde(tag = "type", rename_all = "lowercase")]
pub enum Literal {
    String(YamlString),
}

#[derive(Debug, Serialize, Deserialize, PartialEq)]
#[serde(tag = "type", rename_all = "camelCase")]
pub struct YamlString {
    pub max_length: Option<u64>,
    pub min_length: Option<u64>,
    pub pattern: Option<String>,
}

#[cfg(test)]
mod tests {

    use super::*;

    #[test]
    fn test_any_of() {
        let inputs = [r#"
            anyOf:
                - type: "string"
                  minLength: 1
            "#];
        let expecteds = [YamlSchema::AnyOf {
            any_of: vec![Literal::String(YamlString {
                max_length: None,
                min_length: Some(1),
                pattern: None,
            })],
        }];
        for (expected, input) in expecteds.iter().zip(inputs.iter()) {
            let actual = serde_yaml::from_str(input).unwrap();
            assert_eq!(*expected, actual);
        }
    }

    #[test]
    fn test_all_of() {
        let inputs = [r#"
            allOf:
                - type: "string"
                  minLength: 1
            "#];
        let expecteds = [YamlSchema::AllOf {
            all_of: vec![Literal::String(YamlString {
                max_length: None,
                min_length: Some(1),
                pattern: None,
            })],
        }];
        for (expected, input) in expecteds.iter().zip(inputs.iter()) {
            let actual = serde_yaml::from_str(input).unwrap();
            assert_eq!(*expected, actual);
        }
    }

    #[test]
    fn test_string_literal() {
        let inputs = [
            r#"
            type: "string"
            "#,
            r#"
            type: "string"
            maxLength: 10
            "#,
            r#"
            type: "string"
            minLength: 1
            "#,
            r#"
            type: "string"
            pattern: "^[a-z]+$"
            "#,
        ];
        let expecteds = [
            Literal::String(YamlString {
                max_length: None,
                min_length: None,
                pattern: None,
            }),
            Literal::String(YamlString {
                max_length: Some(10),
                min_length: None,
                pattern: None,
            }),
            Literal::String(YamlString {
                max_length: None,
                min_length: Some(1),
                pattern: None,
            }),
            Literal::String(YamlString {
                max_length: None,
                min_length: None,
                pattern: Some("^[a-z]+$".to_string()),
            }),
        ];
        for (expected, input) in expecteds.iter().zip(inputs.iter()) {
            println!("input: {}", input);
            println!("expected: {:?}", expected);
            let actual = serde_yaml::from_str(input).unwrap();
            assert_eq!(*expected, actual);
        }
    }
}